---
comments: true
title: Django & Wagtail Notes
date: 2025-01-06 12:00:00
image:
    path: /assets/img/images_preview/DjangoDRFPreview.webp
categories: [Programming and Development, Django]
math: true
mermaid: true
pin: true
tags: [programming, django, django-rest-framework]
---

## Django MVT (Model-View-Template)

### Model

- Represents the **data** layer of the application.
- Defines the structure of the database, including tables, fields, and relationships.
- Handles data storage, retrieval, and validation.
- Interacts with the database using Django's ORM (Object-Relational Mapper).

#### Define Relationships

##### Many-to-Many

Should be defined on **either** side of the relationship using `ManyToManyField()`. (Notice that `Category` was passed as a string, because the class `Category` was not defined yet. Django uses a string representation and it's considered the best practice.)

```python
# One product can belongs to many categories, such as bread -> food & on_sale_product
# One category can also has many products, such as food -> bread & chicken
class Product(models.Model):
    name = models.CharField(max_length=50)
    categories = models.ManyToManyField('Category')

    
class Category(models.Model):
    name = models.CharField(max_length=50)
```

##### Many-to-One

Should be defined on the **many** side of the relationship using `ForeignKey()`

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
# Now, the method becomes the value of related_name
```

##### One-to-One

Should be defined on **either** side of the relationship using `OneToOneField()`

### View

- Acts as the **business logic** layer.
- Processes user requests, interacts with the Model to fetch or manipulate data, and prepares the data for rendering.
- Returns a (Django's) `HttpResponse`, often by rendering a template with the processed data.
- In Django, views are typically Python functions or classes.

### Template

- Represents the **presentation** layer.
- Defines how the data is displayed to the user.
- Uses Django's template language to dynamically generate HTML by combining static content with data from the View.
- Separates the design (HTML/CSS) from the logic (Python code).

### Miscellaneous

#### Abstract Class

```python
class AbstractCorporation(models.Model):
    # id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255, unique=True)

    class Meta:
        abstract = True

    def __str__(self):
        return self.name
```

- When defining `abstrat = True` in the subclass `Meta`, no table will be created in the database.

## Wagtail CMS

### Create Admin Menu (Group)

Create `SnippetViewSet` in  `<app_name>/views.py`

```python
from wagtail.snippets.views.snippets import SnippetViewSet, SnippetViewSetGroup
from corp_wechat.models import CorpWechat
from .models import Notificator


class CorpWechatSnippetViewSet(SnippetViewSet):
    model = CorpWechat
    form_class = CorpWechatForm
    icon = "folder-open-inverse"
    menu_label = 'CorpWechat'
    inspect_view_enabled = True


class NotificatorSnippetViewSet(SnippetViewSet):
    model = Notificator
    form_fields = ['name', 'secret', 'corp']
    icon = "folder-open-inverse"
    menu_label = 'Notificator'
    inspect_view_enabled = True


class CorpWechatSnippetViewSetGroup(SnippetViewSetGroup):
    items = (CorpWechatSnippetViewSet, NotificatorSnippetViewSet)
    icon = "crocodile"
    menu_label = "CorpWeChat"
    inspect_view_enabled = True
    add_to_admin_menu = True
```

Register `SnippetViewSet` in `<app_name>/wagtail_hooks.py`

```python
from wagtail import hooks
from .views import CorpWechatSnippetViewSetGroup


@hooks.register("register_admin_viewset")
def register_viewset():
    return CorpWechatSnippetViewSetGroup()
```

### Reference

- [SnippetViewSet (Group)](https://docs.wagtail.org/en/stable/reference/viewsets.html#snippetviewset)
- [Icons](https://docs.wagtail.org/en/stable/advanced_topics/icons.html#available-icons)


