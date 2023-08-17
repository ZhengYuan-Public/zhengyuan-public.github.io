---
comments: true
title: Markdown Notes
date: 2020-04-05 12:00:00
categories: [programming, markdown, generic]
tags: [programming, markdown, generic]
---

## Heading

Markdown supports 6 levels of heading with `# x n={1, 2, 3, 4, 5, 6}`

```markdown
# Heading 1 
## Heading 2 
### Heading 3 
#### Heading 4 
##### Heading 5 
##### Heading 6
```

## Emphasizing

### Italic

```markdown
This text is *Italic*.
```

### Bold 

```markdown
This text is **Bold**.
```
### Bold and Italic

```markdown
This text is ***Italic and Bold***.
```
### Strikethrough 

```markdown
This text is ~~Strikethrough~~.
```
### Highlight

```markdown
I ==love== you so much.
```
### Subscript and Subscript

```markdown
y = a~1~x^2^ + b~1~
```

## Blockquotes

\*Put blank lines ***before*** and ***after*** lines starting with `>`.

### Blockquotes with one paragraph

```markdown
> The quick brown fox jumps over the lazy dog.
```

> The quick brown fox jumps over the lazy dog.

### Blockquotes with multiple paragraphs

```markdown
> The quick brown fox jumps over the lazy dog.
>
> Waltz, bad nymph, for quick jigs vex.
```

> The quick brown fox jumps over the lazy dog.
>
> Waltz, bad nymph, for quick jigs vex.

### Nested Blockquotes

```markdown
> The quick brown fox jumps over the lazy dog.
>
>> Waltz, bad nymph, for quick jigs vex.
```

> The quick brown fox jumps over the lazy dog.
>
> > Waltz, bad nymph, for quick jigs vex.

## List

### Ordered list

```markdown
1. First item
2. Second item
```

1. First item
2. Second item

### Unordered list

```markdown
- First item
- Second item
- 1024\. A lovely number! (escape with \\)
```

- First item
- Second item
- 1024\. A lovely number! (escape with \\)

### Nested list

```markdown
1. First item
    - Indented item
    - Indented item
2. Second item
3. Third item
```

1. First item
    - Indented item
    - Indented item
2. Second item
3. Third item


## Code

````markdown
```<programming_language_name>
Put
	your
		code
			here.
```
````

## Image

```markdown
![Image_alt_name](image_url)
```

## Horizontal Rule

```markdown
---
```

## Links

```markdown
[ZhengYuan - GitHub Page](https://zhengyuan-public.github.io)
<https://zhengyuan-public.github.io>
<fake@example.com>
```

[ZhengYuan - GitHub Page](https://zhengyuan-public.github.io)

<https://zhengyuan-public.github.io>

<fake@example.com>

## Footnotes

```markdown
Here's a simple footnote,[^1] and here's a longer one.[^bignote]

[^1]: This is the first footnote.

[^bignote]: Here's one with multiple paragraphs and code.

    Indent paragraphs to include them in the footnote.

    `{ my code }`

    Add as many paragraphs as you like.
```

Here's a simple footnote,[^1] and here's a longer one.[^bignote]

[^1]: This is the first footnote.

[^bignote]: Here's one with multiple paragraphs and code.

    Indent paragraphs to include them in the footnote.
    
    `{ my code }`
    
    Add as many paragraphs as you like.

## Task list

```markdown
- [x] Get up
- [ ] Take a nap
- [ ] Go to sleep
```

- [x] Get up
- [ ] Take a nap
- [ ] Go to sleep

## Table

Use three ore more hyphens (`-`) to create each column’s header; 

Use  pipes (`|`) to separate each column; 

Use colons (`:`) to align text.

```markdown
| Syntax      | Description | Test Text     |
| :---        |    :----:   |          ---: |
| Header      | Title       | Here's this   |
| Paragraph   | Text        | And more      |
```

| Syntax    | Description |   Test Text |
| :-------- | :---------: | ----------: |
| Header    |    Title    | Here's this |
| Paragraph |    Text     |    And more |

## YAML header

```markdown
---
comments: true
title: Markdown Notes
date: 2020-04-05 12:00:00
categories: [programming, markdown, generic]
tags: [programming, markdown, generic]
---
```

## Mathematics

```markdown
When $a \ne 0$, there are two solutions to $(ax^2 + bx + c = 0)$ and they are 
$$ x = {-b \pm \sqrt{b^2-4ac} \over 2a} $$.
```

## Collapsible Sections

From this [GitHub Page](https://gist.github.com/pierrejoubert73/902cc94d79424356a8d20be2b382e1ab) :link: 

```markdown
<details>
  <summary>Click me</summary>
  
  ### Heading
  1. Foo
  2. Bar
     * Baz
     * Qux

</details>

```

- Always have an **empty line** after the `</summary>` tag
- Always have an **empty line** after each `</details>` tag
- *Typora might have some problem rendering it [Typora issue #499](https://github.com/typora/typora-issues/issues/499).


## Useful Resources

[Markdown Guide - Basic Syntax](https://www.markdownguide.org/basic-syntax/) :link:

[Markdown Guide - Extended Syntax](https://www.markdownguide.org/extended-syntax/) :link:

[Markdown Cheat Sheet](https://www.markdownguide.org/cheat-sheet/) :link: 

[Complete list of GitHub markdown emoji markup](https://gist.github.com/rxaviers/7360908) :link: 

## --->EOF

(Footnotes below)