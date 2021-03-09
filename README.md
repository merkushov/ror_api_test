# README

Тестовая задача на Ruby про API, Redis и RSpec

[Описание задачи](TASK_DESCRIPTION.md)

Инструкция по запуску тестового приложения. Перед запуском, установите в систему Docker

```
git clone git@github.com:merkushov/ror_api_test.git ror_api_test
cd ror_api_test

cd devops
docker-compose build

# тестирование
docker-compose run -e "RAILS_ENV=test" funbox_merkushov_web rake spec

# запуск приложения
docker-compose up -d
```

Проверка работоспособности

```
curl -XPOST "http://localhost:3000/visited_links" -H 'Content-Type: application/json' -d '{"links": ["https://ya.ru","https://ya.ru?q=123","funbox.ru","https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"]}'

curl "http://localhost:3000/visited_domains?from=1613991170&to=2615991170"
```
