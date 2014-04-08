python-build Cookbook
======================

This cookbook build and install several python versions from official source.
Python-2.4, 2.5, 2.6, 2.7, 3.0, 3.1, 3.2, 3.3. however 3.0 is limited work with 'packages' attribute.

Requirements
------------

#### cookbook
- `build-essential` - building python needs gcc and related headers.

Attributes
----------

#### python-build::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>["python_build"]["archive_url_base"]</tt></td>
    <td>string</td>
    <td>Python source file location. python official site is default.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>["python_build"]["configure_options"]</tt></td>
    <td>array</td>
    <td>configure options</td>
    <td><tt>['--enable-shared']</tt></td>
  </tr>
  <tr>
    <td><tt>["python_build"]["install_prefix"]</tt></td>
    <td>string</td>
    <td>Install path prefix</td>
    <td><tt>"/usr/local"</tt></td>
  </tr>
  <tr>
    <td><tt>["python_build"]["versions"]</tt></td>
    <td>string</td>
    <td>Install versions list. If you want to specify default version of python then it place last of the list. for example: `"versions": ["2.5.6", "3.3.1", "2.7.3"]`</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>["python_build"]["packages"]</tt></td>
    <td>string</td>
    <td>Install python 3rd-party package list. "setuptools" will install by default. BTW setuptools did not support Python-3.0 then this feature did not work when specify '3.0.x' in versions.</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>["python_build"]["owner"]</tt></td>
    <td>string</td>
    <td>Install file/directory owner.</td>
    <td><tt>"root"</tt></td>
  </tr>
  <tr>
    <td><tt>["python_build"]["group"]</tt></td>
    <td>string</td>
    <td>Install file/directory group.</td>
    <td><tt>"root"</tt></td>
  </tr>
  <tr>
    <td><tt>["python_build"]["find_links"]</tt></td>
    <td>string</td>
    <td>list of package urls for easy_install -f</td>
    <td><tt>[]</tt></td>
  </tr>
</table>

Usage
-----
#### python-build::default

Include `python-build` in your node's `run_list` and specify `python_build` attributes:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[python-build]"
  ],
  "override_attributes" : {
    "python_build": {
      "versions" : ["2.6.8", "2.7.3", "3.2.3", "3.3.0"],
      "packages" : ["pip", "tox", "virtualenv"]
    }
  }
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Takayuki Shimizukawa
License: Apache 2.0
