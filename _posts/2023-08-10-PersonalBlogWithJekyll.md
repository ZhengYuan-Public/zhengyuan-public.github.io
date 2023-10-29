---
comments: true
title: Personal Blog with Jekyll
date: 2023-08-10 12:00:00
image:
    path: /assets/img/images_preview/JekyllPreview.png
math: true
categories: [Website, Jekyll]
tags: [website, jekyll]
---

## A Brief Introduction to Jekyll

Jekyll is a static site generator, also called a site builder, that transforms plain text files into static HTML and CSS files. It was written in **Ruby**, and it is open-source and free to use. Jekyll is a popular choice for creating websites and blogs because it is easy to use and produces fast-loading, lightweight websites. Jekyll websites are also easy to deploy and host on any web server.

### A Brief Introduction to Ruby
Ruby was designed and developed in the mid-1990s by Yukihiro "Matz" Matsumoto in Japan. Ruby is known for its elegant syntax, which makes it easy to read and write. Here are some key features of **Ruby**:

- Object-oriented: Ruby is an object-oriented language, which means that everything in Ruby is an object. This makes it easy to create reusable code and to encapsulate data.
- Dynamic: Ruby is a dynamic language, which means that the type of a variable can change at runtime. This makes Ruby code more flexible and easier to write.
- Reflective: Ruby is a reflective language, which means that Ruby programs can inspect and modify their structure and behavior. This makes it possible to write powerful and flexible code.
- General-purpose: Ruby is a general-purpose language, which means that it can be used to write a wide variety of programs, from web applications to data science scripts.

### Basics of Ruby

- `gem` is a package
- `bundle` is a tool for managing Ruby gem dependencies, similar to `pip` in Python. Bundler has a built-in command to run the project `bundle exec`
- `Gemfile` is a text file that describes the gem dependencies required to execute associated Ruby code.
- `Gemfile.lock`  is a text file that specifies the exact versions of the gems that were installed
- `bundle install` will install all gems listed in the `Gemfile` with specific versions listed in the `Gemfile.lock`. This command will set up everything for the application.
- `gem install` will install gems for your own environment.

### Check which ruby you are using

```bash
$ which ruby
/usr/bin/ruby
# This means you are using the ruby preinstalled by MacOS, which is often outdated.
# Scripting language runtimes such as Python, Ruby, and Perl are included in macOS 
# by default for compatibility with legacy software. 
```

### Install Ruby on macOS with Homebrew

> There are other options, feel free to explore them.
{:  .prompt-tip}

#### Install [Homebrew](https://brew.sh/)

Homebrew is a free and open-source software package management system that simplifies the installation of software on Apple's operating system, macOS, as well as Linux. It's also written in Ruby.

```bash
$ /bin/bash -c "$(curl -fsSL \
https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Install [rbenv](https://github.com/rbenv/rbenv)

rbenv is a version manager tool for the Ruby programming language on Unix-like systems. It is useful for switching between multiple Ruby versions on the same machine and for ensuring that each project you are working on always runs on the correct Ruby version.

```bash
# Install rbenv
$ brew install rbenv ruby-build

# Configure your shell to load rbenv (I'm using zsh)
$ echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc

# Restart your shell after this
```

#### Install Ruby with rbenv

```bash
# List latest stable versions:
$ rbenv install -l

# List all local versions:
$ rbenv install -L

# Install a Ruby version:
$ rbenv install 3.2.2

# Set the default Ruby version for this machine
rbenv global 3.2.2

# Set the Ruby version for this directory
cd ProjectFolder
rbenv local 3.2.2
```

## Start a Jekyll Site

If you also just want something that can be used out of the box, I'd recommend you use a Jekyll theme built by others. Here is a non-exhaustive list of websites where you can find those themes:

- [GitHub.com #jekyll-theme repos](https://github.com/topics/jekyll-theme)
- [jamstackthemes.dev](https://jamstackthemes.dev/ssg/jekyll/)
- [jekyllthemes.org](http://jekyllthemes.org/)
- [jekyllthemes.io](https://jekyllthemes.io/)
- [jekyll-themes.com](https://jekyll-themes.com/)

The one I'm using for now is called [jekyll-theme-chirpy](https://github.com/cotes2020/jekyll-theme-chirpy).

## Jekyll Plugins

To add plugins to your Jekyll site, just add a new section in your `_config.yml` and gems in `Gemfile`. Here are the plugins I'm using:

```yaml
# _config.yml
plugins:
  - jemoji
  - jekyll-pdf-embed
  - jekyll-admin
  - jekyll-scholar
  - jekyll-latex
```

```ruby
# Germfile
group :jekyll_plugins do
  gem "jemoji"
  gem "jekyll-pdf-embed"
  gem "jekyll-admin"
  gem "jekyll-scholar"
  gem "jekyll-latex"
end
```

### Jekyll-Scholar for Academic Scholars

Create a new folder `_bibliography` at the project root, and add your [configuration](https://github.com/inukshuk/jekyll-scholar#configuration) in `_config.yml`

```yaml
scholar:
  style: apa
  locale: en
  sort_by: author
  order: ascending
  source: ./_bibliography
```

You can have a default `.bib` file to store all of your references, but I prefer to use a dedicated `.bib` for each of my posts. For example, I have `papers_cv.bib` under the folder `_bibliography` for my notes on Computer Vision, and here are two entries of papers in BibTex.

```latex
@inproceedings{girshick2014rich,
     title={Rich feature hierarchies for accurate object detection and semantic segmentation},
     author={Girshick, Ross and Donahue, Jeff and Darrell, Trevor and Malik, Jitendra},
     booktitle={Proceedings of the IEEE conference on computer vision and pattern recognition},
     pages={580--587},
     year={2014}
   }

@article{he2015spatial,
     title={Spatial pyramid pooling in deep convolutional networks for visual recognition},
     author={He, Kaiming and Zhang, Xiangyu and Ren, Shaoqing and Sun, Jian},
     journal={IEEE transactions on pattern analysis and machine intelligence},
     volume={37},
     number={9},
     pages={1904--1916},
     year={2015},
     publisher={IEEE}
   }
```

To add a reference at the end of the post, put the following lines at the end of the markdown file. Note that the argument `papers_cv` is from the file name `papers_cv.bib`. A preview can be found in my computer vision notes [here](https://zhengyuan-public.github.io/posts/ComputerVisionNotes/#reference).


{% raw %}
```liquid
## Reference

---

{% bibliography --cited --file papers_cv %}
```
{% endraw %}

To cite the above-mentioned two papers within the post, use the following syntax. They will be rendered as {% cite girshick2014rich --file papers_cv %} and {% cite he2015spatial --file papers_cv %}.
{% raw %} 

```liquid
{% cite girshick2014rich --file papers_cv %} and {% cite he2015spatial --file papers_cv %} 
```
{% endraw %}

## $$ \LaTeX $$ Math Equations in Jekyll

For Jekyll, the procedures to render $$ \LaTeX $$ math equations are:

$$
\text{Markdown} \xrightarrow[]{kramdown} \text{HTML} \xrightarrow[]{MathJax} \text{Math Equation Images}
$$

Where kramdown is the markdown engine used by Jekyll (and GitHub) for translating markdown into HTML, and MathJax is a JavaScript that renders the HTML as images shown on the website. It should be noticed that kramdown has a slightly different syntax compared to standard markdown (see details [here](https://kramdown.gettalong.org/syntax.html#math-blocks)).  I encountered several problems with inline math rendering (see examples [here](https://github.com/mathjax/MathJax/issues/3103)) and here I'd like to summarize my findings on how to avoid those problems.

I usually start writing my notes on Jekyll with Typora (which has its private markdown engine and it works better than kramdown in my humble opinion) and then revise it until it's ready for publication on GitHub. However, the rendered outputs on Jekyll are not always the same as in Typora because of their differences in the markdown engine.

In standard markdown syntax, you should add inline math with `$ math $` and block math with `$$ math $$`. However, the situation is a little complicated in kramdown. If you are not interested in the examples, just jump to the [summary](#summary).

> Here are just the temporary solutions I've found. I believe this is a bug in kramdown, so I'll start an issue and update this part accordingly.
{: .prompt-warning }

### Block math

Block math is almost the same as standard markdown, except a blank line is required both before and after the block math. 

---

Example 1

```markdown
Situation 1 - This is the situation when both blank lines are presented:

$$
\Delta \hat{p}_{i, j} = {\frac {1}{\sigma {\sqrt {2\pi }}}}e^{-{\frac {1}{2}}\left({\frac {x-\mu }{\sigma }}\right)^{2}}
$$

End of situation 1

---

Situation 2 - This is the situation when both blank lines are missing:
$$
\Delta \hat{p}_{i, j} = {\frac {1}{\sigma {\sqrt {2\pi }}}}e^{-{\frac {1}{2}}\left({\frac {x-\mu }{\sigma }}\right)^{2}}
$$
End of situation 2

---

Situation 3 - This is the situation when the blank lines before the first `$$` is missing:
$$
\Delta \hat{p}_{i, j} = {\frac {1}{\sigma {\sqrt {2\pi }}}}e^{-{\frac {1}{2}}\left({\frac {x-\mu }{\sigma }}\right)^{2}}
$$

End of situation 3

---

Situation 4 - This is the situation when the blank lines after the second `$$` is missing:

$$
\Delta \hat{p}_{i, j} = {\frac {1}{\sigma {\sqrt {2\pi }}}}e^{-{\frac {1}{2}}\left({\frac {x-\mu }{\sigma }}\right)^{2}}
$$
End of situation 4

---

```

Situation 1 - This is the situation when both blank lines are presented:

$$
\Delta \hat{p}_{i, j} = {\frac {1}{\sigma {\sqrt {2\pi }}}}e^{-{\frac {1}{2}}\left({\frac {x-\mu }{\sigma }}\right)^{2}}
$$

End of situation 1

---

Situation 2 - This is the situation when both blank lines are missing:
$$
\Delta \hat{p}_{i, j} = {\frac {1}{\sigma {\sqrt {2\pi }}}}e^{-{\frac {1}{2}}\left({\frac {x-\mu }{\sigma }}\right)^{2}}
$$
End of situation 2

---

Situation 3 - This is the situation when the blank lines before the first `$$` is missing:
$$
\Delta \hat{p}_{i, j} = {\frac {1}{\sigma {\sqrt {2\pi }}}}e^{-{\frac {1}{2}}\left({\frac {x-\mu }{\sigma }}\right)^{2}}
$$

End of situation 3

---

Situation 4 - This is the situation when the blank lines after the second `$$` is missing:

$$
\Delta \hat{p}_{i, j} = {\frac {1}{\sigma {\sqrt {2\pi }}}}e^{-{\frac {1}{2}}\left({\frac {x-\mu }{\sigma }}\right)^{2}}
$$
End of situation 4

---

Example 1 above shows that **kramdown treats `$$ math $$` as inline math when a blank line is missing either before or after the double dollar sign**. To avoid any mistakes, ***put a blank line both before and after the math block***.

### Inline math

#### Inline math in lines

---

Example 2

```markdown
Situation 1 - This is the situation when using `$$ math $$` as inline math (this is discovered from the last step, not the recommended syntax by kramdown)

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets $$ \Delta \hat{p}_{i, j} $$ and then transformed to the real offsets $$ \Delta p_{i, j} $$

End of situation 1

---

Situation 2 - This is the situation when using **only one** standard markdown syntax `$ math $` as inline math

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets $ \Delta \hat{p}_{i, j} $ and then transformed to the real offsets

End of situation 2

---

Situation 3 - This is the situation when using **more than one** standard markdown syntax `$ math $` as inline math

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets $ \Delta \hat{p}_{i, j} $ and then transformed to the real offsets $ \Delta p_{i, j} $

End of situation 3

---

Situation 4 - This is the situation when using **only one** kramdown syntax `\$$ math $$` as inline math (this is the recommended syntax by kramdown)

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets \$$ \Delta \hat{p}_{i, j} $$ and then transformed to the real offsets

End of situation 4

---

Situation 5 - This is the situation when using **more than one** kramdown syntax `\$$ math $$` as inline math (this is the recommended syntax by kramdown)

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets \$$ \Delta \hat{p}_{i, j} $$ and then transformed to the real offsets \$$ \Delta p_{i, j} $$

End of situation 5

---

```

Situation 1 - This is the situation when using `$$ math $$` as inline math (this is discovered from last step, not the recommended syntax by kramdown)

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets $$ \Delta \hat{p}_{i, j} $$ and then transformed to the real offsets $$ \Delta p_{i, j} $$

End of situation 1

---

Situation 2 - This is the situation when using **only one** standard markdown syntax `$ math $` as inline math

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets $ \Delta \hat{p}_{i, j} $ and then transformed to the real offsets

End of situation 2

---

Situation 3 - This is the situation when using **more than one** standard markdown syntax `$ math $` as inline math

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets $ \Delta \hat{p}_{i, j} $ and then transformed to the real offsets $ \Delta p_{i, j} $

End of situation 3

---

Situation 4 - This is the situation when using **only one** kramdown syntax `\$$ math $$` as inline math (this is the recommended syntax by kramdown)

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets \$$ \Delta \hat{p}_{i, j} $$ and then transformed to the real offsets

End of situation 4

---

Situation 5 - This is the situation when using **more than one** kramdown syntax `\$$ math $$` as inline math (this is the recommended syntax by kramdown)

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets \$$ \Delta \hat{p}_{i, j} $$ and then transformed to the real offsets \$$ \Delta p_{i, j} $$

End of situation 5

---

Example 2 shows that inline math is fairly complicated with kramdown. 

- Situation 1 shows that **using `$$ math $$` without any blank lines as inline math** is the least error-prone way

- Situation 2 and Situation 3 show a bug exists when using `$ math $` for inline math. The text between two underscores `_` was treated as italic text when it was rendered as HTML and hence the HTML cannot be further rendered correctly by MathJax. More examples can be found in the GitHub issue [here](https://github.com/mathjax/MathJax/issues/3103)

- Situation 4 shows that the [recommended syntax](https://kramdown.gettalong.org/syntax.html#math-blocks:~:text=But%20next%20comes%20a%20paragraph%20with%20an%20inline%20math%20statement) `\$$ math $$` is interpreted as block math

- Situation 5 shows that the [recommended syntax](https://kramdown.gettalong.org/syntax.html#math-blocks:~:text=But%20next%20comes%20a%20paragraph%20with%20an%20inline%20math%20statement) `\$$ math $$` is also affected by two underscores `_`

#### Inline math in lists

---

Example 3

```markdown
Situation 1 - Use `$ math $` as inline math in lists

- $ sign = b_{31} = 0 $
1. $ E = (b_{30}b_{29}...b_{23})_2 = (01111100)_2 = (124)_{10} \in \{1, ..., (2^8-1) - 1 \} = \{1, ..., 254\} $
2. $ (1.b_{22}b_{21} \dots b_{0})_2 = 1 + \sum_{i=1}^{23} b_{23 - i}2^{-i} = 1.25 $

End of situation 1

---

Situation 2 - Use `$$ math $$` as inline math in lists

- $$ sign = b_{31} = 0 $$
1. $$ E = (b_{30}b_{29}...b_{23})_2 = (01111100)_2 = (124)_{10} \in \{1, ..., (2^8-1) - 1 \} = \{1, ..., 254\} $$
2. $$ (1.b_{22}b_{21} \dots b_{0})_2 = 1 + \sum_{i=1}^{23} b_{23 - i}2^{-i} = 1.25 $$

End of situation 2

---

Situation 3 - Use `\$$ math $$` as inline math in lists

- \$$ sign = b_{31} = 0 $$
1. \$$ E = (b_{30}b_{29}...b_{23})_2 = (01111100)_2 = (124)_{10} \in \{1, ..., (2^8-1) - 1 \} = \{1, ..., 254\} $$
2. \$$ (1.b_{22}b_{21} \dots b_{0})_2 = 1 + \sum_{i=1}^{23} b_{23 - i}2^{-i} = 1.25 $$

End of situation 3

---

```

Situation 1 - Use `$ math $` as inline math in lists

- $ sign = b_{31} = 0 $
1. $ E = (b_{30}b_{29}...b_{23})_2 = (01111100)_2 = (124)_{10} \in \{1, ..., (2^8-1) - 1 \} = \{1, ..., 254\} $
2. $ (1.b_{22}b_{21} \dots b_{0})_2 = 1 + \sum_{i=1}^{23} b_{23 - i}2^{-i} = 1.25 $

End of situation 1

---

Situation 2 - Use `$$ math $$` as inline math in lists

- $$ sign = b_{31} = 0 $$
1. $$ E = (b_{30}b_{29}...b_{23})_2 = (01111100)_2 = (124)_{10} \in \{1, ..., (2^8-1) - 1 \} = \{1, ..., 254\} $$
2. $$ (1.b_{22}b_{21} \dots b_{0})_2 = 1 + \sum_{i=1}^{23} b_{23 - i}2^{-i} = 1.25 $$

End of situation 2

---

Situation 3 - Use `\$$ math $$` as inline math in lists

- \$$ sign = b_{31} = 0 $$
1. \$$ E = (b_{30}b_{29}...b_{23})_2 = (01111100)_2 = (124)_{10} \in \{1, ..., (2^8-1) - 1 \} = \{1, ..., 254\} $$
2. \$$ (1.b_{22}b_{21} \dots b_{0})_2 = 1 + \sum_{i=1}^{23} b_{23 - i}2^{-i} = 1.25 $$

End of situation 3

---

Example 3 above shows list of inline math is behaving differently

- `$ math $` is still not working if more than one underscore `_` is presented
- `$$ math $$` without any blank lines is now recognized as block math
- **`\$$ math $$` is the right syntax for a list of inline math**

### Summary 

In Jekyll (with the default markdown engine kramdown), 

- **block math** should be added with `$$ math $$` *with* a blank line both before and after `$$`
- **inline math (normal)** should be added with `$$ math $$` *without* any blank lines before or after `$$`
- **inline math (in lists)** should be added with `\$$ math $$`

> The above solutions have only been tested with [jekyll-theme-chirpy](https://github.com/cotes2020/jekyll-theme-chirpy).
{: .prompt-warning }

## Miscellaneous

### Categories vs Tags

[Categories vs Tags – SEO Best Practices for Sorting Your Content](https://www.wpbeginner.com/beginners-guide/categories-vs-tags-seo-best-practices-which-one-is-better/) :link:

- Categories are meant to **broadly group** your posts. Categories are **hierarchical**, which means you can create **subcategories**.
- Tags are meant to **describe specific details** of your posts. Tags are **not hierarchical**.

There’s no specific number of categories that you should have. In most cases, you will want somewhere between 5 and 10 in order to properly categorize your posts and make your site easy to browse. Categories are meant to encompass a large group of posts. You can use subcategories and tags to split your posts into smaller groups. If you are just starting a blog, then don’t worry about trying to come up with a perfect list of categories. Just choose 3-5 broad categories and add more as time goes by. 

## Jekyll-Scholar Reference Demo

---

{% bibliography --cited --file papers_cv %}