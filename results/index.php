<?php
error_reporting(E_ALL ^ E_DEPRECATED);
include_once 'vendor/autoload.php';
ini_set("memory_limit",-1);
function process($function): array
{
    $dataJson = file_get_contents('resultsFinal.json');
    $dataJson = json_decode($dataJson, true);
    return $dataJson[$function];
}

$s = $_GET['s'] ?? 'home';
$page = $_GET['page'] ?? '1';
$title = '';
$results = [];

if ($page === '1') {
    $title = 'Fibonacci';
    $results = process('fibonacci');
}

if ($page === '2') {
    $title = 'Quicksort';
    $results = process('quicksort');
}

if ($page === '3') {
    $title = 'Thumbnail';
    $results = process('thumbnail');
}

if ($page === '4') {
    $title = 'Users';
    $results = process('users');
}

$data = [
    'page' => $page,
    'title' => $title,
    'results' => $results,
];

use Spatie\Blade\Blade;
$views = __DIR__ . '/views';
$cache = __DIR__ . '/cache';
$blade = new Blade($views, $cache);
echo $blade->view()->make($s, $data);
