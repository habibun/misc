## About The Project
Implements [EasyAdminBundle][easy_admin_github] in [Symfony][symfony_website]

Please check the [projects](#projects) section for more details.

## Overview
| Branch   | EasyAdmin Version | Symfony Version | PHP Version | Node Version |
|----------|-------------------|-----------------|-------------|--------------|
| [v4][v4] | `^4.0`            | `^6.0`          | `^8.1`      | `v16.13`     | 
| [v2][v2] | `^2.3`            | `^4.4`          | `^7.2`      | `~`          |


## Projects
<details><summary>Simple application using EasyAdminBundle v4</summary>  

<img
src="https://user-images.githubusercontent.com/5810350/226254914-a20cb91d-da7a-4417-81d4-4733b749986c.png"
alt="easy admin bundle v4"
width="50%"
/>

**Code:** https://github.com/habibun/easy-admin-bundle/tree/v4  
**Resources:**
 - [EasyAdmin! For an Awesomely Powerful Admin Area](https://symfonycasts.com/screencast/easyadminbundle)

### Prerequisites
- [Symfony CLI][symfony_cli], [PHP][php], [Composer][composer], [Git][git], [MySQL][mysql], [Node.js][node]

### Installation

```bash 
# Clone the repository using the command
git clone git@github.com:habibun/easy-admin-bundle.git

# Navigate into the cloned directory
cd easy-admin-bundle

# Checkout to project branch
git checkout v4

# Create .env.local file
make init
```

Configure the database connection in the .env.local file

```bash 
# Install project
make install

# Start the local development server
make start
```

Please check more rules in [Makefile][v4_makefile].

##
</details>


<details><summary>Simple application using EasyAdminBundle v2</summary>

<img
src="https://user-images.githubusercontent.com/5810350/226255064-bba19bae-ac88-4ea3-a010-97abb549118c.png"
alt="easy admin bundle v2"
width="50%"
/>

**Code:** https://github.com/habibun/easy-admin-bundle/tree/v2  
**Resources:**
- [EasyAdminBundle v1 for an Amazing Admin Interface](https://symfonycasts.com/screencast/easyadminbundle1)


### Prerequisites
[Symfony CLI][symfony_cli], [PHP][php], [Composer][composer], [Git][git], [MySQL][mysql]

### Installation

```bash 
# Clone the repository using the command
git clone git@github.com:habibun/easy-admin-bundle.git

# Navigate into the cloned directory
cd easy-admin-bundle

# Checkout to project branch
git checkout v2

# Create .env.local file
make init
```

Configure the database connection in the .env.local file

```bash 
# Install project
make install

# Start the local development server
make start
```

Please check more rules in [Makefile][v2_makefile].

##
</details>


## Learn More
- [EasyAdmin Docs][easy_admin_docs]


## Related
- [Symfony](https://github.com/habibun/symfony)


## License
Distributed under the MIT License. See **[LICENSE][license]** for more information.


[//]: # (Links)
[license]: https://github.com/habibun/easy-admin-bundle/blob/main/LICENSE
[symfony_website]: https://symfony.com/

[easy_admin_github]: https://github.com/EasyCorp/EasyAdminBundle
[easy_admin_docs]: https://symfony.com/bundles/EasyAdminBundle/current/index.html

[v4]: https://github.com/habibun/easy-admin-bundle/tree/v4
[v4_tt]: https://github.com/habibun/easy-admin-bundle/tree/v4 "Simple application using EasyAdminBundle v4"
[v4_makefile]: https://github.com/habibun/easy-admin-bundle/blob/v4/Makefile

[v2]: https://github.com/habibun/easy-admin-bundle/tree/v2
[v2_tt]: https://github.com/habibun/easy-admin-bundle/tree/v2 "Simple application using EasyAdminBundle v2"
[v2_makefile]: https://github.com/habibun/easy-admin-bundle/blob/v2/Makefile

[symfony_cli]: https://symfony.com/download
[php]: https://www.php.net/
[composer]: https://getcomposer.org/
[git]: https://git-scm.com/
[mysql]: https://www.mysql.com/
[node]: https://nodejs.org/
