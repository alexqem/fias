FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.10

COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

# Set proper ownership
USER root
RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/config/elasticsearch.yml
USER elasticsearch

# Expose ports
EXPOSE 9200 9300