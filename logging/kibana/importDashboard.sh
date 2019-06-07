curl --user steve:docker123 -X POST "http://kibana/api/kibana/dashboards/import?exclude=index-pattern" -d@sample_dashboard.json -H 'kbn-xsrf: true' -H "Content-Type: application/json"
