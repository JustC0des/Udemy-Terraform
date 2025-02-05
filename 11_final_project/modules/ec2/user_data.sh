#!/bin/bash
set -e

yum update -y

yum install -y nginx php php-fpm php-pgsql postgresql16

# Metadata V2 Token abrufen
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

echo "$INSTANCE_ID" > /etc/instance-id
chmod 644 /etc/instance-id

# PostgreSQL Tabellen erstellen
psql postgresql://${postgres_username}:${postgres_password}@${rds_identifier}:5432/postgres <<EOF

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

INSERT INTO users (name, email, password_hash) VALUES
('Alice Müller', 'alice@example.com', 'hashed_password_1'),
('Bob Schmidt', 'bob@example.com', 'hashed_password_2'),
('Charlie Wagner', 'charlie@example.com', 'hashed_password_3'),
('Diana Fischer', 'diana@example.com', 'hashed_password_4'),
('Elias Becker', 'elias@example.com', 'hashed_password_5')
ON CONFLICT (email) DO NOTHING;

EOF

echo "Tabellen wurden erstellt oder existieren bereits."
echo "5 Benutzer wurden hinzugefügt (falls sie noch nicht existierten)."


# Starte und aktiviere PHP-FPM
systemctl enable php-fpm
systemctl start php-fpm

# Erstelle die index.php Datei mit Nutzeranmeldung und EC2-Instance-ID
cat <<EOT > /usr/share/nginx/html/index.php
<?php
\$host = '${rds_identifier}';
\$port = '5432';
\$dbname = 'postgres';
\$user = '${postgres_username}';
\$password = '${postgres_password}';

// Verbindung zur Datenbank
\$conn = pg_connect("host=\$host port=\$port dbname=\$dbname user=\$user password=\$password");

if (!\$conn) {
    die("Fehler: Verbindung zur Datenbank fehlgeschlagen.");
}

// Benutzer hinzufügen
if (\$_SERVER["REQUEST_METHOD"] == "POST") {
    \$name = \$_POST['name'];
    \$email = \$_POST['email'];
    \$password = password_hash(\$_POST['password'], PASSWORD_DEFAULT);
    
    \$query = "INSERT INTO users (name, email, password_hash) VALUES (\$1, \$2, \$3)";
    \$result = pg_query_params(\$conn, \$query, array(\$name, \$email, \$password));
    
    if (\$result) {
        echo "<p style='color: green;'>Neuer Benutzer erfolgreich hinzugefügt!</p>";
    } else {
        echo "<p style='color: red;'>Fehler beim Hinzufügen des Benutzers.</p>";
    }
}

// Benutzer anzeigen
\$result = pg_query(\$conn, "SELECT id, name, email FROM users");

echo "<h1>Benutzerliste</h1>";
echo "<table border='1'><tr><th>ID</th><th>Name</th><th>Email</th></tr>";

while (\$row = pg_fetch_assoc(\$result)) {
    echo "<tr><td>{\$row['id']}</td><td>{\$row['name']}</td><td>{\$row['email']}</td></tr>";
}

echo "</table>";

// Eingabeformular
echo "<h2>Neuen Benutzer hinzufügen</h2>
<form method='POST'>
    Name: <input type='text' name='name' required><br>
    Email: <input type='email' name='email' required><br>
    Passwort: <input type='password' name='password' required><br>
    <button type='submit'>Benutzer hinzufügen</button>
</form>";

// EC2-Instance-ID aus Datei lesen
\$instance_id = trim(file_get_contents("/etc/instance-id"));

echo "<div style='position:fixed; bottom:10px; right:10px; background-color:#000; color:#fff; padding:10px; border-radius:5px; font-family:Arial;'>
    EC2 Instance: " . htmlspecialchars(\$instance_id) . "
</div>";

pg_close(\$conn);
?>
EOT

# Setze die EC2-Instance-ID als Umgebungsvariable für PHP
echo "export INSTANCE_ID=$INSTANCE_ID" >> /etc/environment

# Nginx-Konfiguration für PHP
cat <<EOT > /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php-fpm/www.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param INSTANCE_ID "$INSTANCE_ID";
    }
}
EOT

# Nginx neu starten
systemctl restart nginx

echo "Webserver mit Benutzerverwaltung und EC2-Instance-ID ist bereit!"
