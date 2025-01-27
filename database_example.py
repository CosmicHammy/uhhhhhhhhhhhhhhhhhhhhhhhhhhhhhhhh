import mysql.connector

# Connect to the MySQL database
conn = mysql.connector.connect(
    host='localhost',
    user='myuser',
    password='mypassword',
    database='mydatabase'
)

# Create a cursor object
cursor = conn.cursor()

# Create a table
cursor.execute('''
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL
)
''')

# Insert a new user
cursor.execute('''
INSERT INTO users (name, age) VALUES (%s, %s)
''', ('Alice', 30))

# Commit the changes
conn.commit()

# Query the database
cursor.execute('SELECT * FROM users')
rows = cursor.fetchall()
for row in rows:
    print(row)

# Close the connection
conn.close()