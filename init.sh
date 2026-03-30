#!/bin/bash

/opt/mssql/bin/sqlservr &

echo "Esperando SQL Server..."
sleep 20

echo "Ejecutando scripts recursivos..."

for file in $(find /initDB -name "*.sql" | sort); do
  echo "Ejecutando $file"
  sqlcmd -S localhost \
         -U sa \
         -P "YourStrong@Password123" \
         -C \
         -i "$file"
done

echo "Init completado"

wait