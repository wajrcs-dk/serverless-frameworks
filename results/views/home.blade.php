@extends('layout')

@section('body')
    <header class="pt10 pf zi3 w100p pt0 pl0 df bg4">
        <div class="fg df jcc">
            <ul class="pagination">
                <li class="jcc">
                    <a></a>
                    <a id="page1" class="page-item page-numbers cp" href="?page=1"></a>
                    <a id="page2" class="page-item page-numbers cp" href="?page=2"></a>
                    <a id="page3" class="page-item page-numbers cp" href="?page=3"></a>
                    <a id="page4" class="page-item page-numbers cp" href="?page=4"></a>
                    <a></a>
                </li>
            </ul>
        </div>
    </header>
    <h2 id="title" class="c5 pb5">{{$title}}</h2>
    <h3>Single Pod Function</h3>
    <div class="fg df jcc pt15 pb15">
        <div class="p0_12" id="boxplot-1"></div>
        <div class="p0_12" id="chart-1"></div>
        <div class="p0_12" id="time-1"></div>
    </div>
    <h3>Auto-scaling</h3>
    <div class="fg df jcc pt15 pb15">
        <div class="p0_12" id="boxplot-2"></div>
        <div class="p0_12" id="chart-2"></div>
        <div class="p0_12" id="time-2"></div>
    </div>
    <script>
        $('#page{{$page}}').addClass('current');
        renderBarChart("#chart-1",
            [{{$results['barChart'][0][0][0]}}, {{$results['barChart'][0][0][1]}}, {{$results['barChart'][0][0][2]}}, {{$results['barChart'][0][0][3]}}],
            [{{$results['barChart'][0][1][0]}}, {{$results['barChart'][0][1][1]}}, {{$results['barChart'][0][1][2]}}, {{$results['barChart'][0][1][3]}}],
            [{{$results['barChart'][0][2][0]}}, {{$results['barChart'][0][2][1]}}, {{$results['barChart'][0][2][2]}}, {{$results['barChart'][0][2][3]}}],
            [{{$results['barChart'][0][3][0]}}, {{$results['barChart'][0][3][1]}}, {{$results['barChart'][0][3][2]}}, {{$results['barChart'][0][3][3]}}],
            [{{$results['barChart'][0][4][0]}}, {{$results['barChart'][0][4][1]}}, {{$results['barChart'][0][4][2]}}, {{$results['barChart'][0][4][3]}}],
            false
        );
        renderBoxPlot("#boxplot-1",
            [{{$results['boxPlot'][0][0][0]}}, {{$results['boxPlot'][0][0][1]}}, {{$results['boxPlot'][0][0][2]}}, {{$results['boxPlot'][0][0][3]}}, {{$results['boxPlot'][0][0][4]}}],
            [{{$results['boxPlot'][0][1][0]}}, {{$results['boxPlot'][0][1][1]}}, {{$results['boxPlot'][0][1][2]}}, {{$results['boxPlot'][0][1][3]}}, {{$results['boxPlot'][0][1][4]}}],
            [{{$results['boxPlot'][0][2][0]}}, {{$results['boxPlot'][0][2][1]}}, {{$results['boxPlot'][0][2][2]}}, {{$results['boxPlot'][0][2][3]}}, {{$results['boxPlot'][0][2][4]}}],
            [{{$results['boxPlot'][0][3][0]}}, {{$results['boxPlot'][0][3][1]}}, {{$results['boxPlot'][0][3][2]}}, {{$results['boxPlot'][0][3][3]}}, {{$results['boxPlot'][0][3][4]}}],
            [{{$results['boxPlot'][0][4][0]}}, {{$results['boxPlot'][0][4][1]}}, {{$results['boxPlot'][0][4][2]}}, {{$results['boxPlot'][0][4][3]}}, {{$results['boxPlot'][0][4][4]}}],
            {{$results['boxPlot'][0][0][5]}},
            {{$results['boxPlot'][0][1][5]}},
            {{$results['boxPlot'][0][2][5]}},
            {{$results['boxPlot'][0][3][5]}},
            {{$results['boxPlot'][0][4][5]}}
        );
        renderTimeSeries("#time-1",
            {{json_encode($results['series'][0][0])}},
            {{json_encode($results['series'][0][1])}},
            {{json_encode($results['series'][0][2])}},
            {{json_encode($results['series'][0][3])}},
            {{json_encode($results['series'][0][4])}},
            {{json_encode($results['series'][0][5])}},
        );
        renderBarChart("#chart-2",
            [{{$results['barChart'][1][0][0]}}, {{$results['barChart'][1][0][1]}}, {{$results['barChart'][1][0][2]}}, {{$results['barChart'][1][0][3]}}, {{$results['barChart'][1][0][4]}}, {{$results['barChart'][1][0][5]}}],
            [{{$results['barChart'][1][1][0]}}, {{$results['barChart'][1][1][1]}}, {{$results['barChart'][1][1][2]}}, {{$results['barChart'][1][1][3]}}, {{$results['barChart'][1][1][4]}}, {{$results['barChart'][1][1][5]}}],
            [{{$results['barChart'][1][2][0]}}, {{$results['barChart'][1][2][1]}}, {{$results['barChart'][1][2][2]}}, {{$results['barChart'][1][2][3]}}, {{$results['barChart'][1][2][4]}}, {{$results['barChart'][1][2][5]}}],
            [{{$results['barChart'][1][3][0]}}, {{$results['barChart'][1][3][1]}}, {{$results['barChart'][1][3][2]}}, {{$results['barChart'][1][3][3]}}, {{$results['barChart'][1][3][4]}}, {{$results['barChart'][1][3][5]}}],
            [{{$results['barChart'][1][4][0]}}, {{$results['barChart'][1][4][1]}}, {{$results['barChart'][1][4][2]}}, {{$results['barChart'][1][4][3]}}, {{$results['barChart'][1][4][4]}}, {{$results['barChart'][1][4][5]}}],
            true
        );
        renderBoxPlot("#boxplot-2",
            [{{$results['boxPlot'][1][0][0]}}, {{$results['boxPlot'][1][0][1]}}, {{$results['boxPlot'][1][0][2]}}, {{$results['boxPlot'][1][0][3]}}, {{$results['boxPlot'][1][0][4]}}],
            [{{$results['boxPlot'][1][1][0]}}, {{$results['boxPlot'][1][1][1]}}, {{$results['boxPlot'][1][1][2]}}, {{$results['boxPlot'][1][1][3]}}, {{$results['boxPlot'][1][1][4]}}],
            [{{$results['boxPlot'][1][2][0]}}, {{$results['boxPlot'][1][2][1]}}, {{$results['boxPlot'][1][2][2]}}, {{$results['boxPlot'][1][2][3]}}, {{$results['boxPlot'][1][2][4]}}],
            [{{$results['boxPlot'][1][3][0]}}, {{$results['boxPlot'][1][3][1]}}, {{$results['boxPlot'][1][3][2]}}, {{$results['boxPlot'][1][3][3]}}, {{$results['boxPlot'][1][3][4]}}],
            [{{$results['boxPlot'][1][4][0]}}, {{$results['boxPlot'][1][4][1]}}, {{$results['boxPlot'][1][4][2]}}, {{$results['boxPlot'][1][4][3]}}, {{$results['boxPlot'][1][4][4]}}],
            {{$results['boxPlot'][1][0][5]}},
            {{$results['boxPlot'][1][1][5]}},
            {{$results['boxPlot'][1][2][5]}},
            {{$results['boxPlot'][1][3][5]}},
            {{$results['boxPlot'][1][4][5]}}
        );
        renderTimeSeries("#time-2",
            {{json_encode($results['series'][1][0])}},
            {{json_encode($results['series'][1][1])}},
            {{json_encode($results['series'][1][2])}},
            {{json_encode($results['series'][1][3])}},
            {{json_encode($results['series'][1][4])}},
            {{json_encode($results['series'][1][5])}},
        );
        function renderTimeSeries(chartId, fission, knative, nuclio, openFaaS, openWhisk, series) {
            const options = {
                colors: ["#4480da", "#a0d468", "#7a49e3", "#ffcd54", "#fb6e51", '#d9334a'],
                series: [
                    {
                        name: "Fission",
                        data: fission
                    }, {
                        name: "Knative",
                        data: knative
                    }, {
                        name: 'Nuclio',
                        data: nuclio
                    }, {
                        name: 'OpenFaaS',
                        data: openFaaS
                    }, {
                        name: 'OpenWhisk',
                        data: openWhisk
                    }
                ],
                chart: {
                    height: 350,
                    width: 500,
                    type: 'line',
                    zoom: {
                        enabled: false
                    }
                },
                dataLabels: {
                    enabled: false
                },
                stroke: {
                    width: [3, 3, 3, 3, 3],
                    curve: 'straight',
                    dashArray: [0, 0, 0, 0, 0]
                },
                legend: {
                    offsetY: -25,
                    markers: {
                        radius: 2
                    }
                },
                markers: {
                    size: 0,
                    hover: {
                        sizeOffset: 6
                    }
                },
                xaxis: {
                    categories: series,
                    title: {
                        text: "Requests Series",
                        offsetY: -30,
                        style: {
                            fontSize:  '13px',
                            fontWeight:  'bold',
                            fontFamily:  "Arial",
                            color:  '#263238'
                        },
                    }
                },
                yaxis: {
                    title: {
                        text: 'Response Time (Sec)'
                    }
                },
                grid: {
                    borderColor: '#f1f1f1',
                }
            };
            const chart = new ApexCharts(document.querySelector(chartId), options);
            chart.render();
        }

        function renderBoxPlot(chartId, fission, knative, nuclio, openFaaS, openWhisk, fissionC, knativeC, nuclioC, openFaaSC, openWhiskC) {
            const options = {
                xaxis: {
                    title: {
                        text: "Serverless Frameworks",
                        style: {
                            fontSize:  '13px',
                            fontWeight:  'bold',
                            fontFamily:  "Arial",
                            color:  '#263238'
                        },
                    }
                },
                yaxis: {
                    title: {
                        text: 'Response Time (Sec)'
                    }
                },
                series: [
                    {
                        name: 'box',
                        type: 'boxPlot',
                        data: [
                            {
                                x: 'Fission',
                                y: fission
                            },
                            {
                                x: 'Knative',
                                y: knative
                            },
                            {
                                x: 'Nuclio',
                                y: nuclio
                            },
                            {
                                x: 'OpenFaaS',
                                y: openFaaS
                            },
                            {
                                x: 'openWhisk',
                                y: openWhisk
                            }
                        ]
                    }
                ],
                chart: {
                    type: 'boxPlot',
                    height: 350,
                    width: 500,
                    zoom: {
                        enabled: false
                    }
                },
                plotOptions: {
                    boxPlot: {
                        colors: {
                            upper: '#4480da',
                            lower: '#a0d468'
                        }
                    }
                },
                tooltip: {
                    shared: false,
                    intersect: true
                }
            };
            const chart = new ApexCharts(document.querySelector(chartId), options);
            chart.render();
        }

        function renderBarChart(chartId, fission, knative, nuclio, openFaaS, openWhisk, series) {
            let categories = [];
            if (series === false) {
                categories = ['10', '50', '150', 'Average'];
            } else {
                categories = ['10', '50', '150', '250', '1000', 'Average'];
            }
            const options = {
                legend: {
                    offsetY: 0,
                },
                colors: ["#4480da", "#a0d468", "#7a49e3", "#ffcd54", "#fb6e51", '#d9334a'],
                series: [{
                    name: 'Fission',
                    data: fission
                }, {
                    name: 'Knative',
                    data: knative
                }, {
                    name: 'Nuclio',
                    data: nuclio
                }, {
                    name: 'OpenFaaS',
                    data: openFaaS
                }, {
                    name: 'OpenWhisk',
                    data: openWhisk
                }],
                chart: {
                    type: 'bar',
                    height: 350,
                    width: 500,
                },
                plotOptions: {
                    bar: {
                        horizontal: false,
                        columnWidth: '55%',
                        endingShape: 'rounded'
                    },
                },
                dataLabels: {
                    enabled: false
                },
                stroke: {
                    show: true,
                    width: 2,
                    colors: ['transparent']
                },
                xaxis: {
                    categories: categories,
                    title: {
                        text: "Concurrent Requests",
                        style: {
                            fontSize:  '13px',
                            fontWeight:  'bold',
                            fontFamily:  "Arial",
                            color:  '#263238'
                        },
                    }
                },
                yaxis: {
                    title: {
                        text: 'Throughput (RPS)'
                    }
                },
                fill: {
                    opacity: 1
                },
                tooltip: {
                    y: {
                        formatter: function (val) {
                            return val + " Requests"
                        }
                    }
                }
            };
            const chart = new ApexCharts(document.querySelector(chartId), options);
            chart.render();
        }
    </script>
@endsection