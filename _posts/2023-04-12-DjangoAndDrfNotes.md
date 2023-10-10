---
comments: true
title: Django & Django REST Framework Notes
date: 2023-04-12 12:00:00
image:
    https://miro.medium.com/v2/resize:fit:4800/format:webp/1*lAMsvtB6afHwTQYCNM1xvw.png
categories: [Website, Django, Python]
tags: [website, django, python, programming, django-rest-framework]
---

## Setup Project

### Virtual Environment

```shell
python -m venv .venv
. .venv/bin/activate
pip install django
pip install djangorestframework

pip install markdown			
# Markdown support for the browsable API

pip install django-filter		
# Filtering support

pip install djangorestframework-simplejwt	
# JWT auth

pip install coreapi
# Depricated, use OpenAI instaed
```

### Start Project and App

```shell
django-admin startproject DRF_API_Base .
django-admin startapp base_app

python manage.py makemigrations
python manage.py migrate

python manage.py migrate createsuperuser
```

### Update database

```shell
python manage.py makemigrations
python manage.py migrate
```

### Use MySQL(skipped)

### Configure Project Level Settings 

`DRF_API_Base/settings.py`

```python
LANGUAGE_CODE = 'zh-hans'
TIME_ZONE = 'Asia/Shanghai'

# Media folder
STATIC_URL = 'static/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
MEDIA_URL = '/media/'

# Add custom apps
INSTALLED_APPS = [
] + [
    'base_app'
]
```

## Define Relationships in Django

### Many-to-Many

Should be defined on **either side** of the relationship using `ManyToManyField()`. (Notice that `Category` was passed as a string, because the class `Category` was not defined yet. Django uses a string representation and it's considered the best practice.)

```python
# One product can belongs to many categories, such as bread -> food & on_sale_product
# One category can also has many products, such as food -> bread & chicken
class Product(models.Model):
    name = models.CharField(max_length=50)
    categories = models.ManyToManyField('Category')

    
class Category(models.Model):
    name = models.CharField(max_length=50)
```

### Many-to-One

Should be defined on the **"many" side** of the relationship using `ForeignKey()`

```python
class Order(models.Model):
    order_number = models.CharField(max_length=50)
    customer = models.ForeignKey('Customer', on_delete=models.CASCADE)

    
class Customer(models.Model):
    name = models.CharField(max_length=50)
```

The kwarg: `related_name` 

```python
class Author(models.Model):
    name = models.CharField(max_length=50)
    
 
# Case 1
class Book(models.Model):
    title = models.CharField(max_length=200)
    author = models.ForeignKey('Author', on_delete=models.CASCADE)

author = Author.objects.all(name='Zheng Yuan')
books = author.book_set.all()  
# Default method <class_lowercase>_set

# Case 2
class Book(models.Model):
    title = models.CharField(max_length=200)
    author = models.ForeignKey('Author', 
                               related_name='books',
                               on_delete=models.CASCADE)

books = author.books.all()
# Now, the method now becomes the value of related_name
```

### One-to-One

Should be defined on **either side** of the relationship using `OneToOneField()`

## DRF Views

DRF provides `APIView`, a subclass of Django's `View`, with the following differences:

- **Input**: *Requests* became DRF's `Request` instead of Django's `HttpRequest` instances.
- **Output**: returns DRF's `Response` instead of Django's `HttpResponse` instances.
- `APIException` will be caught and mediated into appropriate responses.
- Incoming requests will be authenticated and appropriate permission and/or throttle checks will be run before dispatching the request to the handler method.


### Class-based Views

### Function-Based Views

### API Policy Decorators

### View Schema Decorator

## Generic Views

[Doc Reference](https://www.django-rest-framework.org/api-guide/generic-views/) :link:

### Minxins

## ViewSets

[Doc Reference](https://www.django-rest-framework.org/api-guide/viewsets) :link: