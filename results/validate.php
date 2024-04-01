<?php

function readCsv($file, $iteration): array
{
    echo 'Processing File: ', $file, PHP_EOL;
    $results = [];
    if (file_exists($file)) {
        $file = fopen($file, 'r');
        while (($line = fgetcsv($file)) !== FALSE) {
            if ($line[6] !== 'status-code') {
                if (!isset($results[$line[6]])) {
                    $results[$line[6]] = 0;
                }
                $results[$line[6]]++;
            }
        }
        fclose($file);
    } else {
        echo 'File Not Found: ', $file, PHP_EOL;
    }
    return $results;
}

function process()
{
    $frameworks = ['fission', 'knative', 'nuclio', 'openfaas', 'openwhisk'];
    $functions = ['fibonacci', 'quicksort', 'thumbnail', 'users'];
    $iterations = [
        '-single-10', '-single-50', '-single-150', '-single-200k', '-multiple-10', '-multiple-50', '-multiple-150',
        '-multiple-250', '-multiple-1000', '-multiple-200k'
    ];
    $finalJson = [];
    foreach ($frameworks as $framework) {
        foreach ($functions as $function) {
            foreach ($iterations as $key => $iteration) {
                $finalJson[$framework][$function][$key] = readCsv('../' . $framework . '/functions/' . $function . '/' . $function.$iteration. '.csv', $iteration);
            }
        }
    }
    file_put_contents('validate.json', json_encode($finalJson));
}

process();