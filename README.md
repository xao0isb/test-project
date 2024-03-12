# Тестовое задание

Был реализован весь функционал технического задания. В процессе использовались технологии, указанные в вакансии, а именно:

  - Ruby 3
  - Ruby On Rails 7
  - PostgreSQL в качестве базы данных
  - Rspec для тестирования
  - DelayedJob для асинхронных задач
  - Pundit для точечной авторизации
  - Devise для реализации регистрации/авторизации
  - Bootstrap

Также использовались:
  - AASM в качестве стейт-машины
  - Carrierwave для реализации функционала прикрепления изображений и файлов к постам
  - Fast Excel для генирации excel-отчетов
  - Rubocop для линтинга

## Локальный запуск:

База данных:
```bash
rails db:prepare
```

Запускаем Postres.

DelayedJob:
```bash
RAILS_ENV=test bin/delayed_job start
```

Сервер:
```bash
rails s
```

Тестирование:
```bash
rspec
```

Линтинг:
```bash
bundle exec rubocop
slim-lint app/views/
```
