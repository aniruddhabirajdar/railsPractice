# Active Record Queries in Rails

---

## 1. **Users Who Have Posted in the Last Month**

Retrieve a list of users who have created at least one post in the last month:
```ruby
User.distinct.includes(:posts).references(:posts).where("posts.created_at >= ?", 1.month.ago)
```

### Explanation:
- **`distinct`**: Ensures unique users are returned.
- **`includes(:posts)`**: Eager loads posts to avoid N+1 queries.
- **`references(:posts)`**: Ensures the SQL query includes the necessary `posts` table.
- **`where("posts.created_at >= ?", 1.month.ago)`**: Filters posts created within the last month.

### SQL Equivalent:
```sql
SELECT DISTINCT users.*
FROM users
JOIN posts ON posts.user_id = users.id
WHERE posts.created_at >= NOW() - INTERVAL '1 month';
```

---

## 2. **Number of Users Who Posted in the Last Month**

Retrieve the count of unique users who posted in the last month:
```ruby
User.distinct.includes(:posts).references(:posts).where("posts.created_at >= ?", 1.month.ago).count
```

### Explanation:
- **`references(:posts)`**: Ensures the SQL query includes the necessary `posts` table.
- **`count`**: Returns the number of distinct users who meet the criteria.

### SQL Equivalent:
```sql
SELECT COUNT(DISTINCT users.id) AS user_count
FROM users
JOIN posts ON posts.user_id = users.id
WHERE posts.created_at >= NOW() - INTERVAL '1 month';
```

---

## 3. **Users Who Posted in the Last Month (Using MAX)**

Retrieve users based on the latest post creation time:
```ruby
User.left_joins(:posts).group('users.id').having("MAX(posts.created_at) > ?", 30.days.ago)
```

### Explanation:
- **`left_joins(:posts)`**: Includes all users, even those without posts.
- **`group('users.id')`**: Groups results by user ID for aggregation.
- **`having("MAX(posts.created_at) > ?", 30.days.ago)`**: Filters users whose most recent post is within the last month.

### SQL Equivalent:
```sql
SELECT users.*
FROM users
LEFT JOIN posts ON posts.user_id = users.id
GROUP BY users.id
HAVING MAX(posts.created_at) > NOW() - INTERVAL '30 days';
```

To count these users:
```ruby
User.left_joins(:posts).references(:posts).group('users.id').having("MAX(posts.created_at) > ?", 30.days.ago).count
```

---

## 4. **Users Who Haven't Posted in the Last Month**

Retrieve users who have not posted in the last month or have no posts at all:
```ruby
User.left_joins(:posts)
    .group('users.id')
    .having("MAX(posts.created_at) < ? OR MAX(posts.created_at) IS NULL", 30.days.ago)
```

### Explanation:
- **`MAX(posts.created_at) IS NULL`**: Ensures users without posts are included.
- **`MAX(posts.created_at) < ?`**: Filters users whose most recent post is older than a month.

### SQL Equivalent:
```sql
SELECT users.*
FROM users
LEFT JOIN posts ON posts.user_id = users.id
GROUP BY users.id
HAVING MAX(posts.created_at) < NOW() - INTERVAL '30 days' OR MAX(posts.created_at) IS NULL;
```

---

## 5. **Users Without Any Posts**

Retrieve users who have never created a post:
```ruby
User.left_joins(:posts)
    .group('users.id')
    .having('COUNT(posts.id) = ?', 0)
```

### Explanation:
- **`left_joins(:posts)`**: Includes all users, even those without posts.
- **`group('users.id')`**: Groups results by user ID for aggregation.
- **`having('COUNT(posts.id) = ?', 0)`**: Filters users with no posts.

### SQL Equivalent:
```sql
SELECT users.*
FROM users
LEFT JOIN posts ON posts.user_id = users.id
GROUP BY users.id
HAVING COUNT(posts.id) = 0;
```

---

## 6. **Count of Orders by Status**

Retrieve the count of orders grouped by their status:
```ruby
Order.group(:status).count
```

### Explanation:
- **`group(:status)`**: Groups orders by their `status` field.
- **`count`**: Returns a hash with the status as the key and the count as the value.

### SQL Equivalent:
```sql
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status;
```

---

## 7. **All Items Sold**

Retrieve all items associated with completed orders:
```ruby
Item.joins(:orders).where(orders: { status: 'completed' })
```

### Explanation:
- **`joins(:orders)`**: Performs an inner join between items and orders.
- **`where(orders: { status: 'completed' })`**: Filters orders with a `status` of `completed`.

### SQL Equivalent:
```sql
SELECT items.*
FROM items
INNER JOIN orders ON orders.item_id = items.id
WHERE orders.status = 'completed';
```

---

## 8. **Get Posts from Specific Categories**

Retrieve posts associated with a specific category:
```ruby
Post.joins(:categories).where(categories: { name: 'Technology' })
```

### Explanation:
- **`joins(:categories)`**: Performs an inner join between posts and categories.
- **`where(categories: { name: 'Technology' })`**: Filters posts belonging to the "Technology" category.

### SQL Equivalent:
```sql
SELECT posts.*
FROM posts
INNER JOIN categories_posts ON categories_posts.post_id = posts.id
INNER JOIN categories ON categories.id = categories_posts.category_id
WHERE categories.name = 'Technology';
```

---

## 9. **Get Categories and Count of Posts**

Retrieve categories and the count of associated posts:
```ruby
Category.joins(:posts).group('categories.id').select("categories.name, COUNT(posts.id) AS posts_count")
```

### Explanation:
- **`joins(:posts)`**: Performs an inner join between categories and posts.
- **`group('categories.id')`**: Groups results by category ID.
- **`select("categories.name, COUNT(posts.id) AS posts_count")`**: Retrieves the category name and the count of posts, aliased as `posts_count`.

### SQL Equivalent:
```sql
SELECT categories.name, COUNT(posts.id) AS posts_count
FROM categories
INNER JOIN posts ON posts.category_id = categories.id
GROUP BY categories.id;
```

---

## 10. **Raw SQL Queries for Specific Use Cases**

### Find Users Who Have Posted in the Last Month
```sql
SELECT DISTINCT users.*
FROM users
JOIN posts ON posts.user_id = users.id
WHERE posts.created_at >= NOW() - INTERVAL '1 month';
```

### Count of Users Who Posted in the Last Month
```sql
SELECT COUNT(DISTINCT users.id) AS user_count
FROM users
JOIN posts ON posts.user_id = users.id
WHERE posts.created_at >= NOW() - INTERVAL '1 month';
```

### Users Who Have Not Posted in the Last Month
```sql
SELECT users.*
FROM users
LEFT JOIN posts ON posts.user_id = users.id
GROUP BY users.id
HAVING MAX(posts.created_at) < NOW() - INTERVAL '30 days' OR MAX(posts.created_at) IS NULL;
```

### Count of Posts by Category
```sql
SELECT categories.name, COUNT(posts.id) AS posts_count
FROM categories
JOIN posts ON posts.category_id = categories.id
GROUP BY categories.id;
```

---



