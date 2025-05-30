#!/bin/bash
# ===============================
# DATABASE BACKUP & RESTORE SCRIPT
# ===============================

DB_NAME="mydatabase"
DB_USER="root"
DB_PASS="yourpassword"
BACKUP_DIR="./backup"
TIMESTAMP=$(date +%F_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$TIMESTAMP.sql"

mkdir -p $BACKUP_DIR

echo "Starting backup of database '$DB_NAME'..."
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "Backup successful: $BACKUP_FILE"
else
  echo "Backup failed!"
  exit 1
fi

echo "Dropping and recreating database '$DB_NAME' for restore test..."
mysql -u $DB_USER -p$DB_PASS -e "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u $DB_USER -p$DB_PASS -e "CREATE DATABASE $DB_NAME;"

echo "Restoring database from backup..."
mysql -u $DB_USER -p$DB_PASS $DB_NAME < $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "Restore successful from: $BACKUP_FILE"
else
  echo "Restore failed!"
  exit 1
fi

echo "Running validation queries to ensure data integrity..."

# Validation queries output
mysql -u $DB_USER -p$DB_PASS -e "
USE $DB_NAME;

-- 1. Count customers
SELECT 'Customers count:' AS Description, COUNT(*) AS Count FROM customers;

-- Expected output:
-- Description       | Count
-- ------------------+-------
-- Customers count:  | 3

-- 2. Count orders
SELECT 'Orders count:' AS Description, COUNT(*) AS Count FROM orders;

-- Expected output:
-- Description    | Count
-- ---------------+-------
-- Orders count:  | 4

-- 3. Check orphan orders (orders with invalid customer_id)
SELECT 'Orphan orders:' AS Description, COUNT(*) AS Count
FROM orders o LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Expected output:
-- Description    | Count
-- ---------------+-------
-- Orphan orders: | 0

"

echo "Backup and restore process completed successfully."
