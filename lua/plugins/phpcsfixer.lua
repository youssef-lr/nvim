return {
  'stephpy/vim-php-cs-fixer',
  config = function()
    vim.g.php_cs_fixer_path = "/Users/youssef/Expensidev/Web-Expensify/vendor/bin/php-cs-fixer"
    vim.g.php_cs_fixer_config_file = "/Users/youssef/Expensidev/PHP-Libs/.php-cs-fixer.php"
    vim.g.php_cs_fixer_php_path = "php"
    vim.g.php_cs_fixer_enable_default_mapping = 1
    vim.g.php_cs_fixer_dry_run = 0
    vim.g.php_cs_fixer_verbose = 0
    vim.g.php_cs_fixer_ignore_env = 1
    vim.g.php_cs_fixer_level = 'all'
  end
}
