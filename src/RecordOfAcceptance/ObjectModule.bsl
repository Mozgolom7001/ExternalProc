﻿Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.3.1.73");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	ПараметрыРегистрации.Версия = "1.0";
	// Определение объектов, к которым подключается эта обработка.
	ПараметрыРегистрации.Назначение.Добавить("Документ.РеализацияТоваровУслуг");
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'Акт сдачи-приемки'");
	НоваяКоманда.Идентификатор = "АктСдачиПриемки";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	НоваяКоманда.Модификатор = "ПечатьMXL";
	
	Возврат ПараметрыРегистрации;
КонецФункции

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктСдачиПриемки");
	Если ПечатнаяФорма <> Неопределено Тогда
		ПечатнаяФорма.ТабличныйДокумент = СформироватьАктСдачиПриемки(МассивОбъектов, ОбъектыПечати);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт сдачи-приемки'");
	КонецЕсли;
КонецПроцедуры

Функция СформироватьАктСдачиПриемки(МассивОбъектов, ОбъектыПечати)
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_АктСдачиПриемки";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	
	ЗаполнитьТабличныйДокументАктСдачиПриемки(
	ТабличныйДокумент,
	МассивОбъектов,
	ОбъектыПечати,
	"ПФ_MXL_АктСдачиПриемки");
	
	Возврат ТабличныйДокумент;
КонецФункции

// <Описание процедуры>
//
// Параметры:
//  ТабличныйДокумент	 - 	 - 
//  ДанныеДляПечати		 - 	 - 
//  ОбъектыПечати		 - 	 - 
//  ИмяМакета			 - 	 - 
//
Процедура ЗаполнитьТабличныйДокументАктСдачиПриемки(ТабличныйДокумент, МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	УстановитьПривилегированныйРежим(Истина); 
		
	ИспользоватьРучныеСкидки         = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользоватьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
	|	РеализацияТоваровУслуг.Номер КАК Номер,
	|	РеализацияТоваровУслуг.Дата КАК Дата,
	|	РеализацияТоваровУслуг.Партнер КАК Партнер,
	|	РеализацияТоваровУслуг.Контрагент КАК Получатель,
	|	РеализацияТоваровУслуг.Организация КАК Организация,
	|	РеализацияТоваровУслуг.Организация.Префикс КАК Префикс,
	|	РеализацияТоваровУслуг.Валюта КАК Валюта,
	|	РеализацияТоваровУслуг.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ВЫБОР
	|		КОГДА РеализацияТоваровУслуг.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС)
	|				ИЛИ РеализацияТоваровУслуг.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК УчитыватьНДС,
	|	РеализацияТоваровУслуг.Отпустил КАК ОтпускПроизвел
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка В(&МассивДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
	|
	|	ВариантыКомплектацииНоменклатуры.Ссылка                                    КАК ВариантКомплектацииНоменклатуры,
	|	ВариантыКомплектацииНоменклатуры.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВариантыКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора                  КАК ВариантРасчетаЦеныНабора,
	|	РеализацияТоваровУслуг.НоменклатураНабора                                  КАК НоменклатураНабора,
	|	РеализацияТоваровУслуг.ХарактеристикаНабора                                КАК ХарактеристикаНабора,
	|
	|	РеализацияТоваровУслуг.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА РеализацияТоваровУслуг.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА 1
	|		ИНАЧЕ &ТекстЗапросаКоэффициентУпаковки1
	|	КОНЕЦ КАК Коэффициент,
	|	ВЫБОР
	|		КОГДА РеализацияТоваровУслуг.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА РеализацияТоваровУслуг.Номенклатура.ЕдиницаИзмерения
	|		ИНАЧЕ РеализацияТоваровУслуг.Упаковка
	|	КОНЕЦ КАК ЕдиницаИзмерения,
	|	РеализацияТоваровУслуг.ПроцентРучнойСкидки + РеализацияТоваровУслуг.ПроцентАвтоматическойСкидки КАК ПроцентСкидки,
	|	РеализацияТоваровУслуг.Характеристика КАК Характеристика,
	|	РеализацияТоваровУслуг.Упаковка КАК Упаковка,
	|	РеализацияТоваровУслуг.СтавкаНДС КАК СтавкаНДС,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			РеализацияТоваровУслуг.Цена
	|		ИНАЧЕ РеализацияТоваровУслуг.Сумма/РеализацияТоваровУслуг.КоличествоУпаковок 
	|	КОНЕЦ КАК Цена,
	|	РеализацияТоваровУслуг.Количество         КАК Количество,
	|	РеализацияТоваровУслуг.КоличествоУпаковок КАК КоличествоУпаковок,
	|	РеализацияТоваровУслуг.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			РеализацияТоваровУслуг.СуммаРучнойСкидки + РеализацияТоваровУслуг.СуммаАвтоматическойСкидки
	|		ИНАЧЕ 0 
	|	КОНЕЦ КАК СуммаСкидки,
	|	РеализацияТоваровУслуг.Сумма + РеализацияТоваровУслуг.СуммаРучнойСкидки + РеализацияТоваровУслуг.СуммаАвтоматическойСкидки КАК СуммаБезСкидки,
	|	РеализацияТоваровУслуг.СуммаНДС КАК СуммаНДС,
	|	РеализацияТоваровУслуг.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслуг
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|		ПО ВариантыКомплектацииНоменклатуры.Владелец = РеализацияТоваровУслуг.НоменклатураНабора
	|		И ВариантыКомплектацииНоменклатуры.Характеристика = РеализацияТоваровУслуг.ХарактеристикаНабора
	|		И ВариантыКомплектацииНоменклатуры.Основной
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка В(&МассивДокументов)
	|	И &УсловиеПоТипуНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка                КАК Ссылка,
	|	ТаблицаТоваров.НоменклатураНабора    КАК НоменклатураНабора,
	|	ТаблицаТоваров.ХарактеристикаНабора  КАК ХарактеристикаНабора,
	|	МИНИМУМ(ТаблицаТоваров.НомерСтроки)  КАК НомерСтроки,
	|	СУММА(ТаблицаТоваров.Сумма)          КАК Сумма,
	|	СУММА(ТаблицаТоваров.СуммаБезСкидки) КАК СуммаБезСкидки,
	|	СУММА(ТаблицаТоваров.СуммаСкидки)    КАК СуммаСкидки,
	|	СУММА(ТаблицаТоваров.СуммаНДС)       КАК СуммаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыПодготовка
	|ИЗ
	|	Товары КАК ТаблицаТоваров
	|
	|ГДЕ
	|	ТаблицаТоваров.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.НоменклатураНабора,
	|	ТаблицаТоваров.ХарактеристикаНабора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка                                    КАК Ссылка,
	|	Товары.ВариантКомплектацииНоменклатуры           КАК ВариантКомплектацииНоменклатуры,
	|	Товары.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	Товары.ВариантРасчетаЦеныНабора                  КАК ВариантРасчетаЦеныНабора,
	|	Товары.НоменклатураНабора,
	|	Товары.ХарактеристикаНабора,
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	ВЫБОР КОГДА Товары.ВариантКомплектацииНоменклатуры.НоменклатураОсновногоКомпонента = Товары.Номенклатура
	|		И Товары.ВариантКомплектацииНоменклатуры.ХарактеристикаОсновногоКомпонента = Товары.Характеристика ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ОсновнаяКомплектующая,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	0 КАК КоличествоПоУмолчанию,
	|	Товары.Количество КАК Количество
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыДополнительноЧастьПервая
	|ИЗ
	|	Товары КАК Товары
	|
	|ГДЕ
	|	Товары.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Т.Ссылка                                                                                КАК Ссылка,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка                                           КАК ВариантКомплектацииНоменклатуры,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.ВариантРасчетаЦеныНабора                  КАК ВариантРасчетаЦеныНабора,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Владелец                                  КАК НоменклатураНабора,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Характеристика                            КАК ХарактеристикаНабора,
	|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура   КАК Номенклатура,
	|	ВариантыКомплектацииНоменклатурыТовары.Характеристика КАК Характеристика,
	|	ЛОЖЬ КАК ОсновнаяКомплектующая,
	|	NULL КАК СтавкаНДС,
	|	СУММА(ВариантыКомплектацииНоменклатурыТовары.Количество) КАК КоличествоПоУмолчанию,
	|	0 КАК Количество
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ВариантыКомплектацииНоменклатурыТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ Т.Ссылка ИЗ Товары КАК Т) КАК Т
	|		ПО ИСТИНА
	|ГДЕ
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка В (ВЫБРАТЬ РАЗЛИЧНЫЕ Т.ВариантКомплектацииНоменклатуры ИЗ Товары КАК Т)
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Ссылка,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Владелец,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Характеристика,
	|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура,
	|	ВариантыКомплектацииНоменклатурыТовары.Характеристика,
	|	ВариантыКомплектацииНоменклатурыТовары.Упаковка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка,
	|	Таблица.ВариантКомплектацииНоменклатуры,
	|	Таблица.ВариантРасчетаЦеныНабора,
	|	Таблица.ВариантПредставленияНабораВПечатныхФормах,
	|	Таблица.НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	МАКСИМУМ(Таблица.СтавкаНДС) КАК СтавкаНДС,
	|	МАКСИМУМ(Таблица.ОсновнаяКомплектующая) КАК ОсновнаяКомплектующая,
	|	СУММА(Таблица.КоличествоПоУмолчанию) КАК КоличествоПоУмолчанию,
	|	СУММА(Таблица.Количество) КАК Количество
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыДополнительноЧастьВторая
	|ИЗ
	|	ВременнаяТаблицаНаборыДополнительноЧастьПервая КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Ссылка,
	|	Таблица.ВариантКомплектацииНоменклатуры,
	|	Таблица.ВариантРасчетаЦеныНабора,
	|	Таблица.ВариантПредставленияНабораВПечатныхФормах,
	|	Таблица.НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Результат.Ссылка,
	|	Результат.ВариантКомплектацииНоменклатуры,
	|	Результат.ВариантРасчетаЦеныНабора,
	|	Результат.ВариантПредставленияНабораВПечатныхФормах,
	|	Результат.НоменклатураНабора,
	|	Результат.ХарактеристикаНабора,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Результат.ОсновнаяКомплектующая
	|				ТОГДА Результат.СтавкаНДС
	|			ИНАЧЕ null
	|		КОНЕЦ) КАК СтавкаНДС,
	|	ВЫРАЗИТЬ(МИНИМУМ(ВЫБОР
	|			КОГДА Результат.КоличествоПоУмолчанию <> 0 И Результат.ОсновнаяКомплектующая
	|				ТОГДА Результат.Количество / Результат.КоличествоПоУмолчанию
	|			ИНАЧЕ null
	|		КОНЕЦ) + 0.5 КАК Число(10,0)) - 1 КАК Количество,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Результат.КоличествоПоУмолчанию <> 0
	|				ТОГДА Результат.Количество / Результат.КоличествоПоУмолчанию
	|			ИНАЧЕ null
	|		КОНЕЦ) КАК КоэффициентМаксимум,
	|	ВЫРАЗИТЬ(МИНИМУМ(ВЫБОР
	|			КОГДА Результат.КоличествоПоУмолчанию <> 0
	|				ТОГДА Результат.Количество / Результат.КоличествоПоУмолчанию
	|			ИНАЧЕ null
	|		КОНЕЦ) + 0.5 КАК Число(10,0)) - 1 КАК КоэффициентМинимум
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыДополнительно
	|ИЗ
	|	ВременнаяТаблицаНаборыДополнительноЧастьВторая КАК Результат
	|СГРУППИРОВАТЬ ПО
	|	Результат.Ссылка,
	|	Результат.ВариантКомплектацииНоменклатуры,
	|	Результат.ВариантРасчетаЦеныНабора,
	|	Результат.ВариантПредставленияНабораВПечатныхФормах,
	|	Результат.НоменклатураНабора,
	|	Результат.ХарактеристикаНабора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаНаборыДополнительно.ВариантКомплектацииНоменклатуры,
	|
	|	ВЫБОР КОГДА Таблица.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию) ТОГДА
	|		ВЫБОР КОГДА ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах = ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор) ТОГДА
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)
	|		ИНАЧЕ
	|			ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах
	|		КОНЕЦ
	|	ИНАЧЕ
	|		ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах
	|	КОНЕЦ КАК ВариантПредставленияНабораВПечатныхФормах,
	|
	|	ВЫБОР КОГДА Таблица.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию) ТОГДА
	|		ВЫБОР КОГДА
	|			ВЫБОР КОГДА ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах = ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор) ТОГДА
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)
	|			ИНАЧЕ
	|				ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах
	|			КОНЕЦ = ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)
	|			И ВременнаяТаблицаНаборыДополнительно.ВариантРасчетаЦеныНабора В (ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам),ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям)) ТОГДА
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих)
	|		ИНАЧЕ
	|			ВременнаяТаблицаНаборыДополнительно.ВариантРасчетаЦеныНабора
	|		КОНЕЦ
	|	ИНАЧЕ
	|		ВременнаяТаблицаНаборыДополнительно.ВариантРасчетаЦеныНабора
	|	КОНЕЦ КАК ВариантРасчетаЦеныНабора,
	|
	|	Таблица.Ссылка                            КАК Ссылка,
	|	Таблица.НоменклатураНабора                КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора              КАК ХарактеристикаНабора,
	|	Таблица.НомерСтроки                       КАК НомерСтроки,
	|	ЕСТЬNULL(ВременнаяТаблицаНаборыДополнительно.Количество, 1) КАК КоличествоУпаковок,
	|	ЕСТЬNULL(ВременнаяТаблицаНаборыДополнительно.Количество, 1) КАК Количество,
	|	ВЫБОР КОГДА ВременнаяТаблицаНаборыДополнительно.КоэффициентМинимум = ВременнаяТаблицаНаборыДополнительно.КоэффициентМаксимум ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ КАК ПолныйНабор,
	|	Таблица.Сумма                                 КАК Сумма,
	|	Таблица.СуммаБезСкидки                        КАК СуммаБезСкидки,
	|	Таблица.СуммаСкидки                           КАК СуммаСкидки,
	|	Таблица.СуммаНДС                              КАК СуммаНДС,
	|	ВременнаяТаблицаНаборыДополнительно.СтавкаНДС КАК СтавкаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборы
	|ИЗ
	|	ВременнаяТаблицаНаборыПодготовка КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаНаборыДополнительно КАК ВременнаяТаблицаНаборыДополнительно
	|		ПО Таблица.НоменклатураНабора = ВременнаяТаблицаНаборыДополнительно.НоменклатураНабора
	|		И Таблица.ХарактеристикаНабора = ВременнаяТаблицаНаборыДополнительно.ХарактеристикаНабора
	|		И Таблица.Ссылка = ВременнаяТаблицаНаборыДополнительно.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Ссылка КАК Ссылка,
	|	ВложенныйЗапрос.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВложенныйЗапрос.ВариантРасчетаЦеныНабора                  КАК ВариантРасчетаЦеныНабора,
	|	ВложенныйЗапрос.НоменклатураНабора								КАК НоменклатураНабора,
	|	ВложенныйЗапрос.ХарактеристикаНабора								КАК ХарактеристикаНабора,
	|	ВложенныйЗапрос.ЭтоНабор КАК ЭтоНабор,
	|	ВложенныйЗапрос.ЭтоКомплектующие КАК ЭтоКомплектующие,
	|	ВложенныйЗапрос.ПолныйНабор КАК ПолныйНабор,
	|
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК ТоварНаименованиеПолное,
	|	ВложенныйЗапрос.Номенклатура.Код КАК Код,
	|	ВложенныйЗапрос.Номенклатура.Артикул КАК Артикул,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Наименование КАК ЕдиницаЦены,
	|	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.Характеристика.НаименованиеПолное КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) = 1
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ВложенныйЗапрос.Упаковка.Наименование
	|	КОНЕЦ КАК Упаковка,
	|	ВложенныйЗапрос.СтавкаНДС КАК СтавкаНДС,
	|	ВложенныйЗапрос.Цена КАК Цена,
	|	ВложенныйЗапрос.КоличествоУпаковок КАК Количество,
	|	ВложенныйЗапрос.Сумма КАК Сумма,
	|	ВложенныйЗапрос.СуммаСкидки КАК СуммаСкидки,
	|	ВложенныйЗапрос.СуммаБезСкидки КАК СуммаБезСкидки,
	|	ВложенныйЗапрос.СуммаНДС КАК СуммаНДС,
	|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА
	|			ВложенныйЗапрос.Ссылка.ВернутьМногооборотнуюТару
	|			И ВложенныйЗапрос.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЭтоВозвратнаяТара
	|ИЗ
	|(
	|	ВЫБРАТЬ
	|		Таблица.Ссылка,
	|
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ПустаяСсылка)
	|		КОНЕЦ КАК ВариантПредставленияНабораВПечатныхФормах,
	|
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.ВариантРасчетаЦеныНабора
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ПустаяСсылка)
	|		КОНЕЦ КАК ВариантРасчетаЦеныНабора,
	|
	|		Таблица.НоменклатураНабора,
	|		Таблица.ХарактеристикаНабора,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|		КОНЕЦ КАК ЭтоКомплектующие,
	|		ЛОЖЬ КАК ЭтоНабор,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.НомерСтроки
	|		ИНАЧЕ
	|			Таблица.НомерСтроки
	|		КОНЕЦ КАК НомерСтроки,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.ПолныйНабор
	|		ИНАЧЕ
	|			ЛОЖЬ
	|		КОНЕЦ КАК ПолныйНабор,
	|		Таблица.Номенклатура,
	|		Таблица.Количество,
	|		Таблица.КоличествоУпаковок,
	|		Таблица.Цена,
	|		Таблица.Сумма,
	|		Таблица.СтавкаНДС,
	|		Таблица.СуммаНДС,
	|		Таблица.Характеристика,
	|		Таблица.Упаковка,
	|		Таблица.ЕдиницаИзмерения,
	|		Таблица.СуммаСкидки,
	|		Таблица.СуммаБезСкидки
	|	ИЗ
	|		Товары КАК Таблица
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаНаборы КАК ВременнаяТаблицаНаборы
	|			ПО ВременнаяТаблицаНаборы.НоменклатураНабора = Таблица.НоменклатураНабора
	|			 И ВременнаяТаблицаНаборы.ХарактеристикаНабора = Таблица.ХарактеристикаНабора
	|			 И ВременнаяТаблицаНаборы.Ссылка = Таблица.Ссылка
	|
	|	ГДЕ
	|		Таблица.НоменклатураНабора = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|		ИЛИ (Таблица.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	        И ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах В (ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоКомплектующие),
	|	                                                                              ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)))
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ВременнаяТаблицаНаборы.Ссылка,
	|		ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах,
	|		ВременнаяТаблицаНаборы.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора,
	|		ВременнаяТаблицаНаборы.НоменклатураНабора,
	|		ВременнаяТаблицаНаборы.ХарактеристикаНабора,
	|		ЛОЖЬ КАК ЭтоКомплектующие,
	|		ИСТИНА КАК ЭтоНабор,
	|		ВременнаяТаблицаНаборы.НомерСтроки,
	|		ВременнаяТаблицаНаборы.ПолныйНабор,
	|		ВременнаяТаблицаНаборы.НоменклатураНабора,
	|		ВременнаяТаблицаНаборы.Количество,
	|		ВременнаяТаблицаНаборы.КоличествоУпаковок,
	|		ВЫБОР
	|			КОГДА &ОтображатьСкидки ТОГДА
	|				ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.КоличествоУпаковок, 1) <> 0 ТОГДА
	|					(ВременнаяТаблицаНаборы.СуммаБезСкидки) / ЕСТЬNULL(ВременнаяТаблицаНаборы.КоличествоУпаковок, 1)
	|				ИНАЧЕ
	|					0
	|				КОНЕЦ
	|			ИНАЧЕ
	|				ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.КоличествоУпаковок, 1) <> 0 ТОГДА
	|					(ВременнаяТаблицаНаборы.Сумма) / ЕСТЬNULL(ВременнаяТаблицаНаборы.КоличествоУпаковок, 1)
	|				ИНАЧЕ
	|					0
	|				КОНЕЦ
	|		КОНЕЦ КАК Цена,
	|		ВременнаяТаблицаНаборы.Сумма КАК Сумма,
	|		ВременнаяТаблицаНаборы.СтавкаНДС,
	|		ВременнаяТаблицаНаборы.СуммаНДС,
	|		ВременнаяТаблицаНаборы.ХарактеристикаНабора,
	|		ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка,
	|		ВременнаяТаблицаНаборы.НоменклатураНабора.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ВременнаяТаблицаНаборы.СуммаСкидки,
	|		ВременнаяТаблицаНаборы.СуммаБезСкидки
	|	ИЗ
	|		ВременнаяТаблицаНаборы КАК ВременнаяТаблицаНаборы
	|	ГДЕ
	|		ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах В (ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор),
	|	                                                           ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие))
	|) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.Ссылка,
	|	НомерСтроки,
	|	ЭтоНабор УБЫВ
	|ИТОГИ
	|	СУММА(СуммаСкидки)
	|ПО
	|	Ссылка");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"РеализацияТоваровУслуг.Упаковка",
			"РеализацияТоваровУслуг.Номенклатура"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ВложенныйЗапрос.Упаковка",
			"ВложенныйЗапрос.Номенклатура"));
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		УсловиеПоТипуНоменклатуры = "ИСТИНА";
	Иначе
		УсловиеПоТипуНоменклатуры = "РеализацияТоваровУслуг.Номенклатура.ТипНоменклатуры  В 
		         |(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеПоТипуНоменклатуры",УсловиеПоТипуНоменклатуры);

	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("ОтображатьСкидки", Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктСдачиПриемки";
	
	МассивРезультатов 		= Запрос.ВыполнитьПакет();
	ДанныеПечати			= МассивРезультатов[0].Выбрать();
	ВыборкаПоДокументам 	= МассивРезультатов[7].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ПоказыватьНДС = Константы.ВыводитьДопКолонкиНДС.Получить();
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		// Найдем в выборке товары по текущему документу
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		НайденСледующий = ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска);
		
		// Если в накладной только услуги - перейдем к следующему документу
		
		Если НайденСледующий Тогда
			ВыборкаПоТоварам = ВыборкаПоДокументам.Выбрать();
			ВыборкаПоТоварам.Сбросить();
		Иначе
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В документе %1 отсутствуют товары. Печать Акта сдачи-приемки не требуется'"),
				ДанныеПечати.Ссылка);
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		
		// Макет необходимо получать для каждого документа, т.к. размеры колонок изменяются динамически.
		Макет = ПолучитьМакет(ИмяМакета);
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент    = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаДокумента");
		
		СтруктураДанныхШапки = Новый Структура;
				
		ПредставлениеПоставщика                         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата), "ПолноеНаименование");
		СтруктураДанныхШапки.Вставить("НаименованиеПродавца", ПредставлениеПоставщика);
		ПредставлениеПолучателя                         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Получатель, ДанныеПечати.Дата), "ПолноеНаименование");
		СтруктураДанныхШапки.Вставить("НаименованиеЗаказчика", ПредставлениеПолучателя);
		
		Договор = ДанныеПечати.Ссылка.Договор;
		
		СтруктураДанныхШапки.Вставить("НомерДоговора", Договор.Номер);
		СтруктураДанныхШапки.Вставить("ДатаДоговора", Договор.Дата);
		
		
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхШапки);
		ТабличныйДокумент.Вывести(ОбластьМакета);
				
		СуммаИтого          = 0;
		СуммаИтогоСоСкидкой       = 0;
		НомерСтроки    = 0;
		
		ПустыеДанные = НаборыСервер.ПустыеДанные();
		
		// Выводим строки таблицы Товары
			
		Пока ВыборкаПоТоварам.Следующий() Цикл
			
			Если ВыборкаПоТоварам.ЭтоНабор Тогда
				
				ОбластьМакета = Макет.ПолучитьОбласть("СтрокаКомплект");
				
				НомерСтроки = НомерСтроки + 1;
				СтруктураСтроки = Новый Структура;
				
				СтруктураСтроки.Вставить("НомерПоПорядку", НомерСтроки);
				Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ВыборкаПоТоварам.ТоварНаименованиеПолное,
				ВыборкаПоТоварам.Характеристика,
				,
				,
				);
				
				СтруктураСтроки.Вставить("НаименованиеКомплекта", Товар);
				ОбластьМакета.Параметры.Заполнить(ВыборкаПоТоварам);
				ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				СуммаИтого = СуммаИтого + ВыборкаПоТоварам.СуммаБезСкидки;
				СуммаИтогоСоСкидкой = СуммаИтогоСоСкидкой + ВыборкаПоТоварам.Сумма;
			ИначеЕсли ВыборкаПоТоварам.ЭтоКомплектующие Тогда
				
				ОбластьМакета = Макет.ПолучитьОбласть("СтрокаКомплектующее");
				
				СтруктураСтроки = Новый Структура;
				
				Товар = "    * " + НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ВыборкаПоТоварам.ТоварНаименованиеПолное,
				ВыборкаПоТоварам.Характеристика,
				,
				,
				);
				
				СтруктураСтроки.Вставить("НаименованиеКомплектующего", Товар);
				ОбластьМакета.Параметры.Заполнить(ВыборкаПоТоварам);
				ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
			Иначе
				
				ОбластьМакета = Макет.ПолучитьОбласть("СтрокаКомплект");
				
				НомерСтроки = НомерСтроки + 1;
				СтруктураСтроки = Новый Структура;
				
				СтруктураСтроки.Вставить("НомерПоПорядку", НомерСтроки);
				Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ВыборкаПоТоварам.ТоварНаименованиеПолное,
				ВыборкаПоТоварам.Характеристика,
				,
				,
				);
				
				СтруктураСтроки.Вставить("НаименованиеКомплекта", Товар);
				ОбластьМакета.Параметры.Заполнить(ВыборкаПоТоварам);
				ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				СуммаИтого = СуммаИтого + ВыборкаПоТоварам.СуммаБезСкидки;
				СуммаИтогоСоСкидкой = СуммаИтогоСоСкидкой + ВыборкаПоТоварам.Сумма;
			
			КонецЕсли; 
			
						
			
		КонецЦикла;
		
		// Выводим подвал
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалДокумента");
		СтруктураПодвал = Новый Структура;
		СтруктураПодвал.Вставить("СуммаИтого", ФормированиеПечатныхФорм.ФорматСумм(СуммаИтого));
		СтруктураПодвал.Вставить("СуммаИтогоСоСкидкой", ФормированиеПечатныхФорм.ФорматСумм(СуммаИтогоСоСкидкой));
	
        ОбластьМакета.Параметры.Заполнить(СтруктураПодвал);
				
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;

	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
		
КонецПроцедуры // ЗаполнитьТабличныйДокументДоговорСпецификация()
