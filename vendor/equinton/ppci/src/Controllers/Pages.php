<?php


use CodeIgniter\Exceptions\PageNotFoundException; 
class Pages extends BaseController
{
    public function index()
    {
        return view('welcome_message');
    }

    public function view($page = 'home')
    {
        $s = service('Smarty');
        $s->set("1.0", "version");
        $s->set("09/02/2024","versiondate");
        printA($_SESSION);
        return $s->send();

    }
}