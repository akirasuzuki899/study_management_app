json.array! @task_templates do |task_template|
  json.extract! task_template, :id
  json.start_time I18n.localize task_template.start_time
end