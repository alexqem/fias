<?php

return [
    'default' => env('ELASTICSEARCH_CONNECTION', 'default'),

    'connections' => [
        'default' => [
            'hosts' => [
                [
                    'host' => env('ELASTICSEARCH_HOST', 'elasticsearch'),
                    'port' => env('ELASTICSEARCH_PORT', 9200),
                    'scheme' => env('ELASTICSEARCH_SCHEME', 'http'),
                    'user' => env('ELASTICSEARCH_USER', null),
                    'pass' => env('ELASTICSEARCH_PASS', null),
                ],
            ],
            'retries' => 1,
            'logging' => [
                'enabled' => true,
                'level' => env('ELASTICSEARCH_LOG_LEVEL', 'info'),
            ],
        ],
    ],
];
