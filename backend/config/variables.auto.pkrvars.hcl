# These variables `only` for ``packer init`` to test.
# Actually, in our terraform workflow, all variables will be set by image-builder module.
# Following variable only present for test

project_id      = ""
region          = "us-west1"
zone_code       = "a"
xwiki_img_name  = "xwiki-img-test"
img_desc        = "XWiki image from Packer"
