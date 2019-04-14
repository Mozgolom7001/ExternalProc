#language: ru

Функционал: <описание фичи>

Как <Роль>
Я хочу <описание функционала> 
Чтобы <бизнес-эффект> 

Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: <описание сценария>

	И В командном интерфейсе я выбираю 'НСИ и администрирование' 'Продажи'
	Тогда открылось окно 'Продажи'
	И я разворачиваю группу "Оптовые продажи"
	И Я закрываю окно 'Продажи'
	И В командном интерфейсе я выбираю 'Продажи' 'Заказы клиентов'
	Тогда открылось окно 'Заказы клиентов'
	И в таблице "Список" я перехожу к строке:
		| '% долга' | '% оплаты' | 'Дата'       | 'Клиент'               | 'Номер'       | 'Операция'   | 'Срок выполнения' | 'Сумма'     | 'Текущее состояние' |
		| '46'      | '46'       | '10.04.2019' | 'Иванов Иван Иванович' | '00ЦУ-000001' | 'Реализация' | '14.04.2019'      | '15 225,00' | 'Готов к отгрузке'  |
	И в таблице "Список" я выбираю текущую строку
	Тогда открылось окно 'Заказ клиента 00ЦУ-000001 от *'
	И я нажимаю на кнопку открытия поля "Договор"
	Тогда открылось окно 'Поставка (Договор с покупателем / заказчиком)'
	И я перехожу к закладке "Расчеты и оформление"
	И я нажимаю на кнопку 'Записать и закрыть'
	И я жду закрытия окна 'Поставка (Договор с покупателем / заказчиком)' в течение 20 секунд
	Тогда открылось окно 'Заказ клиента 00ЦУ-000001 от *'
	И я нажимаю на кнопку 'Договор / спецификация'
	Тогда открылось окно 'Печать документа'
	И в табличном документе 'ТекущаяПечатнаяФорма' я перехожу к ячейке "R1C1:R1C7"
	И Я закрываю окно 'Печать документа'
	Тогда открылось окно 'Заказ клиента 00ЦУ-000001 от *'
	И Я закрываю окно 'Заказ клиента 00ЦУ-000001 от *'
	Тогда открылось окно 'Заказы клиентов'
	И Я закрываю окно 'Заказы клиентов'
