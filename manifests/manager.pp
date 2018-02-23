class { 'docker': }
-> docker_network { 'elk':
  ensure  => present,
  driver  => 'overlay',
  subnet  => '192.168.1.0/24',
  gateway => '192.168.1.1',
}
-> docker::services { 'elasticsearch' :
    create       => true,
    service_name => 'elasticsearch',
    image        => 'docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.1',
    extra_params => [
      '--publish 9300:9300',
      '--publish 9200:9200',
      '--mount type=bind,source=/data/elasticsearch_data,destination=/usr/share/elasticsearch/data',
      '--network elk',
    ],
    replicas     => '1',
    require      => [
      File['/data/elasticsearch_data'],
      Docker_network['elk'],
    ]
  }
