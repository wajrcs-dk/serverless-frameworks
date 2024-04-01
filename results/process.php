<?php

include_once 'vendor/autoload.php';
ini_set("memory_limit",-1);

function removeOutliers($dataset, $magnitude = 1): array
{
    $count = count($dataset);
    $mean = array_sum($dataset) / $count; // Calculate the mean
    $deviation = sqrt(array_sum(array_map("sd_square", $dataset, array_fill(0, $count, $mean))) / $count) * $magnitude; // Calculate standard deviation and times by magnitude
    return array_filter($dataset, function($x) use ($mean, $deviation) { return ($x <= $mean + $deviation && $x >= $mean - $deviation); }); // Return filtered array of values that lie within $mean +- $deviation.
}

function sd_square($x, $mean)
{
    return pow($x - $mean, 2);
}

function perSec($count): int
{
    return (int)round( $count / 300);
}
function avg($arr, $count): int
{
    return (int)( ($arr[0] + $arr[1] + $arr[2]) / $count);
}

function processFinal()
{
    $dataJson = file_get_contents('results.json');
    $dataJson = json_decode($dataJson, true);
    $functions = ['fibonacci', 'quicksort', 'thumbnail', 'users'];
    $resultsFinal = [];
    foreach ($functions as $function) {
        $results = [];
        $singleBarChart = [];
        $multipleBarChart = [];
        $singleBoxPlot = [];
        $multipleBoxPlot = [];
        $singleSeries = [];
        $multipleSeries = [];
        $frameworks = ['fission', 'knative', 'nuclio', 'openfaas', 'openwhisk'];
        $index = 0;
        foreach ($frameworks as $framework) {
            $singleBarChart[$index] = [
                perSec($dataJson[$framework][$function][0]['count']), // 10
                perSec($dataJson[$framework][$function][1]['count']), // 50
                perSec($dataJson[$framework][$function][2]['count']), // 150
            ];
            $singleBarChart[$index][3] = avg($singleBarChart[$index], 3);
            $singleBoxPlot[$index] = [
                $dataJson[$framework][$function][2]['min'],
                $dataJson[$framework][$function][2]['firstQuartile'],
                $dataJson[$framework][$function][2]['mean'],
                $dataJson[$framework][$function][2]['thirdQuartile'],
                $dataJson[$framework][$function][2]['max'],
                $dataJson[$framework][$function][2]['outliers'],
            ];
            $singleSeries[$index] = $dataJson[$framework][$function][3]['series'];
            $multipleBarChart[$index] = [
                perSec($dataJson[$framework][$function][4]['count']), // 10
                perSec($dataJson[$framework][$function][5]['count']), // 50
                perSec($dataJson[$framework][$function][6]['count']), // 150
                perSec($dataJson[$framework][$function][7]['count']), // 250
                perSec($dataJson[$framework][$function][8]['count']), // 1000
            ];
            $multipleBarChart[$index][5] = avg($multipleBarChart[$index], 5);
            $multipleBoxPlot[$index] = [
                $dataJson[$framework][$function][6]['min'],
                $dataJson[$framework][$function][6]['firstQuartile'],
                $dataJson[$framework][$function][6]['mean'],
                $dataJson[$framework][$function][6]['thirdQuartile'],
                $dataJson[$framework][$function][6]['max'],
                $dataJson[$framework][$function][6]['outliers'],
            ];
            $multipleSeries[$index] = $dataJson[$framework][$function][9]['series'];
            $index++;
        }

        $y = [
            count($singleSeries[0]),
            count($singleSeries[1]),
            count($singleSeries[2]),
            count($singleSeries[3]),
            count($singleSeries[4])
        ];
        $diff = 10000;
        $count = max($y);
        foreach ($singleSeries as $key => $series) {
            $t = count($series);
            if ($count > $t) {
                for ($j=$t; $j<$count ; $j++) {
                    $singleSeries[$key][] = 0;
                }
            }
        }
        $singleSeriesNew = [];
        foreach ($singleSeries as $key => $series) {
            $t = count($series);
            for ($j=1; $j<$t ; $j+=$diff) {
                $singleSeriesNew[$key][] = $series[$j];
            }
        }
        $singleSeries = $singleSeriesNew;
        // $count = count($singleSeries[0]);
        echo 'Count ', $count, PHP_EOL;
        $x = [];
        for ($i=1; $i<=$count; $i+=$diff) {
            $x[] = $i;
        }
        $singleSeries[5] = $x;
        $count = max([
            count($multipleSeries[0]),
            count($multipleSeries[1]),
            count($multipleSeries[2]),
            count($multipleSeries[3]),
            count($multipleSeries[4])
        ]);
        foreach ($multipleSeries as $key => $series) {
            $t = count($series);
            if ($count > $t) {
                for ($j=$t; $j<$count ; $j++) {
                    $multipleSeries[$key][] = 0;
                }
            }
        }
        $multipleSeriesNew = [];
        foreach ($multipleSeries as $key => $series) {
            $t = count($series);
            for ($j=1; $j<$t ; $j+=$diff) {
                $multipleSeriesNew[$key][] = $series[$j];
            }
        }
        $multipleSeries = $multipleSeriesNew;
        // $count = count($multipleSeries[0]);
        $x = [];
        for ($i=1; $i<=$count; $i+=$diff) {
            $x[] = $i;
        }
        $multipleSeries[5] = $x;
        $results['barChart'][0] = $singleBarChart;
        $results['barChart'][1] = $multipleBarChart;
        $results['boxPlot'][0] = $singleBoxPlot;
        $results['boxPlot'][1] = $multipleBoxPlot;
        $results['series'][0] = $singleSeries;
        $results['series'][1] = $multipleSeries;
        $resultsFinal[$function] = $results;
    }
    file_put_contents('resultsFinal.json', json_encode($resultsFinal));
}

function readCsv($file, $iteration): array
{
    echo 'Processing File: ', $file, PHP_EOL;
    $list = [];
    $return = [
        'count' => 0,
        'mean' => 0,
        'firstQuartile' => 0,
        'thirdQuartile' => 0,
        'min' => 0,
        'max' => 0,
        'outliers' => 0,
        'series' => []
    ];
    if (file_exists($file)) {
        $file = fopen($file, 'r');
        while (($line = fgetcsv($file)) !== FALSE) {
            if ($line[6] === '200') {
                $list[] = $line[0];
            }
        }
        fclose($file);
        if (count($list) > 0) {
            $newList = removeOutliers($list);
            $stat = HiFolks\Statistics\Statistics::make($newList);
            $return = [
                'count' => $stat->count(),
                'mean' => $stat->mean(),
                'firstQuartile' => $stat->firstQuartile(),
                'thirdQuartile' => $stat->thirdQuartile(),
                'min' => $stat->min(),
                'max' => $stat->max(),
                'outliers' => $stat->count() - count($newList),
                'series' => ($iteration==='-single-200k' || $iteration==='-multiple-200k') ? $list : []
            ];
        }
    } else {
        echo 'File Not Found: ', $file, PHP_EOL;
    }
    return $return;
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
    file_put_contents('results.json', json_encode($finalJson));
}

process();
processFinal();
