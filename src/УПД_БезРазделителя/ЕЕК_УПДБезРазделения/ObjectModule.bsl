﻿Функция СведенияОВнешнейОбработке() Экспорт 

	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	ПараметрыРегистрации.Версия = "1.0";
	ПараметрыРегистрации.Назначение.Добавить("Документ.РеализацияТоваровУслуг");
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
    Команда = ПараметрыРегистрации.Команды.Добавить();
    Команда.Представление = НСтр("ru = 'УПД без разделения на страницы'");
    Команда.Идентификатор = "УПД";
    Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
    Команда.ПоказыватьОповещение = Ложь;
	Команда.Модификатор = "ПечатьMXL";
    Возврат ПараметрыРегистрации;

КонецФункции // СведенияОВнешнейОбработке()
 
Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "УПД") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"УПД",
			НСтр("ru='Универсальный передаточный документ (УПД)'"),
			СформироватьПечатнуюФормуУПД(СтруктураТипов, ОбъектыПечати));
		
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Функция СформироватьПечатнуюФормуУПД(СтруктураТипов, ОбъектыПечати, ПараметрыПечати = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УПД";
	
	СтруктураТиповНаПечать              = Новый Структура;
	МассивСчетФактураВыданный           = Новый Массив;
	МассивСчетФактураКомиссионеру  = Новый Массив;
	МассивСчетФактураПолученный         = Новый Массив;
	ОснованияНаРеализацию               = Новый Массив;
	ОснованияКомиссионеру          = Новый Массив;
	ОснованияСчетФактураПолученный      = Новый Массив;
	ДокументыБезВыданногоСчетаФактуры   = Новый Массив;
	ДокументыБезСчетаФактурыКомиссионеру = Новый Массив;
	ДокументыБезПолученногоСчетаФактуры = Новый Массив;
	
	Если ПараметрыПечати = Неопределено Тогда
		ПараметрыПечати = Новый Структура;
	КонецЕсли;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		ИмяОбъекта = Сред(СтруктураОбъектов.Ключ, 10);
		
		Если ИмяОбъекта = "ОтчетКомитентуОСписании" Или ИмяОбъекта = "ОтчетКомиссионераОСписании" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ИмяОбъекта = "СчетФактураВыданный" Тогда
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивСчетФактураВыданный, СтруктураОбъектов.Значение);
			
		ИначеЕсли ИмяОбъекта = "СчетФактураКомиссионеру" Тогда
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивСчетФактураКомиссионеру, СтруктураОбъектов.Значение);
			
		ИначеЕсли ИмяОбъекта = "ОтчетКомиссионера" Тогда
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОснованияКомиссионеру, СтруктураОбъектов.Значение);
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОснованияНаРеализацию, СтруктураОбъектов.Значение);
			
		КонецЕсли;
		
		Если ПараметрыПечати.Свойство("ДополнитьПолученнымиСчетамиФактуры")
				И ПараметрыПечати.ДополнитьПолученнымиСчетамиФактуры Тогда
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОснованияСчетФактураПолученный, СтруктураОбъектов.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОснованияНаРеализацию.Количество() > 0 Тогда
		
		РезультатАнализа = Документы.СчетФактураВыданный.ПолучитьСчетаФактурыНаПечать(ОснованияНаРеализацию);
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивСчетФактураВыданный, РезультатАнализа.СчетаФактурыНаПечать, Истина);
		
		Для Каждого СтрокаТаблицыОшибок Из РезультатАнализа.ТаблицаОшибок Цикл
			Если СтрокаТаблицыОшибок.НеВыставленСчетФактура Тогда
				ДокументыБезВыданногоСчетаФактуры.Добавить(СтрокаТаблицыОшибок.ДокументОснование);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ОснованияКомиссионеру.Количество() > 0 Тогда
		
		РезультатАнализа = Документы.СчетФактураКомиссионеру.ПолучитьСчетаФактурыНаПечать(ОснованияКомиссионеру);
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивСчетФактураКомиссионеру, РезультатАнализа.СчетаФактурыНаПечать, Истина);
		
		Для Каждого СтрокаТаблицыОшибок Из РезультатАнализа.ТаблицаОшибок Цикл
			Если СтрокаТаблицыОшибок.НеВыставленСчетФактура Тогда
				ДокументыБезВыданногоСчетаФактуры.Добавить(СтрокаТаблицыОшибок.ДокументОснование);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ОснованияСчетФактураПолученный.Количество() > 0 Тогда
		
		РезультатАнализа = Документы.СчетФактураПолученный.ПолучитьСчетаФактурыНаПечать(ОснованияСчетФактураПолученный);
		
		ПараметрыПечати.Вставить("МассивСчетФактураПолученный", РезультатАнализа.СчетаФактурыНаПечать);
		
		Для Каждого СтрокаТаблицыОшибок Из РезультатАнализа.ТаблицаОшибок Цикл
			Если СтрокаТаблицыОшибок.НеВыставленСчетФактура Тогда
				ДокументыБезПолученногоСчетаФактуры.Добавить(СтрокаТаблицыОшибок.ДокументОснование);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если МассивСчетФактураВыданный.Количество() > 0 Тогда
		СтруктураТиповНаПечать.Вставить("СчетФактураВыданный", МассивСчетФактураВыданный);
	КонецЕсли;
	
	Если МассивСчетФактураКомиссионеру.Количество() > 0 Тогда
		СтруктураТиповНаПечать.Вставить("СчетФактураКомиссионеру", МассивСчетФактураКомиссионеру);
	КонецЕсли;
	
	Для Каждого Документ Из ДокументыБезВыданногоСчетаФактуры Цикл
		
		ИмяОбъекта = Документ.Метаданные().Имя;
		Если СтруктураТиповНаПечать.Свойство(ИмяОбъекта) Тогда
			СтруктураТиповНаПечать[ИмяОбъекта].Добавить(Документ);
		Иначе
			МассивДокументовТипа = Новый Массив;
			МассивДокументовТипа.Добавить(Документ);
			СтруктураТиповНаПечать.Вставить(ИмяОбъекта, МассивДокументовТипа);
		КонецЕсли;
		
	КонецЦикла;
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТиповНаПечать Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = Документы[СтруктураОбъектов.Ключ];
		
		ПараметрыПечати.Вставить("НеВыводитьУПДПосредника", Истина);
		
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыУПД(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументУПД(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	СтруктураТиповНаПечать.Очистить();
	Для Каждого Документ Из ДокументыБезПолученногоСчетаФактуры Цикл
		
		ИмяОбъекта = Документ.Метаданные().Имя;
		Если СтруктураТиповНаПечать.Свойство(ИмяОбъекта) Тогда
			СтруктураТиповНаПечать[ИмяОбъекта].Добавить(Документ);
		Иначе
			МассивДокументовТипа = Новый Массив;
			МассивДокументовТипа.Добавить(Документ);
			СтруктураТиповНаПечать.Вставить(ИмяОбъекта, МассивДокументовТипа);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтруктураОбъектов Из СтруктураТиповНаПечать Цикл
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		МенеджерОбъекта = Документы[СтруктураОбъектов.Ключ];
		
		ПараметрыПечати.Вставить("НеВыводитьУПДПосредника", Ложь);
		ПараметрыПечати.Вставить("НеВыводитьОсновнойУПД", Истина);
		
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыУПД(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументУПД(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьРеквизитыШапкиУПД(ДанныеПечати, СведенияОПоставщике, ДанныеКонтрагентов, Макет, ТабличныйДокумент)
	
	СведенияОГрузоотправителе = СведенияОГрузоотправителе(ДанныеПечати);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета,
		ДанныеПечати.Ссылка);
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	
	ПараметрыШапки = Новый Структура;
	
	ПараметрыШапки.Вставить("Номер", НомерСчетаФактурыНаПечать(ДанныеПечати.Номер, ДанныеПечати.ИндексПодразделения));
	ПараметрыШапки.Вставить("Дата", Формат(ДанныеПечати.Дата, "ДЛФ=ДД"));
	ПараметрыШапки.Вставить("НомерИсправления", ?(ДанныеПечати.Исправление, ДанныеПечати.НомерИсправления, "--"));
	ПараметрыШапки.Вставить("ДатаИсправления",
		?(ДанныеПечати.Исправление, Формат(ДанныеПечати.ДатаИсправления, "ДЛФ=ДД"), "--"));
	
	// Выводим данные о поставщике.
	ПредставлениеПоставщика = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Продавец: %1'"),
		СведенияОПоставщике.ОфициальноеНаименование);
	
	АдресПоставщика = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Адрес: %1'"),
		ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ЮридическийАдрес"));
	
	ИННПоставщика = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='ИНН/КПП продавца: %1%2'"),
		ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ИНН", Ложь),
		?(Не ПустаяСтрока(ДанныеПечати.КПППоставщика), "/" + ДанныеПечати.КПППоставщика, ""));
		
	ПараметрыШапки.Вставить("ПредставлениеПоставщика", ПредставлениеПоставщика);
	ПараметрыШапки.Вставить("АдресПоставщика", АдресПоставщика);
	ПараметрыШапки.Вставить("ИННПоставщика", ИННПоставщика);
	
	// Выводим данные грузоотправителя.
	ТекстГрузоотправителя = "";
	Если ДанныеПечати.ТолькоУслуги ИЛИ ДанныеПечати.Грузоотправитель = Неопределено Тогда
		ТекстГрузоотправителя = "--";
	ИначеЕсли ДанныеПечати.Организация = ДанныеПечати.Грузоотправитель Тогда
		ТекстГрузоотправителя = НСтр("ru='он же'");
	Иначе
		ТекстГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(
			СведенияОГрузоотправителе, "ПолноеНаименование,ФактическийАдрес");
	КонецЕсли;
	
	ПредставлениеГрузоотправителя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Грузоотправитель и его адрес: %1'"),
		ТекстГрузоотправителя);
	
	ПараметрыШапки.Вставить("ПредставлениеГрузоотправителя", ПредставлениеГрузоотправителя);
	
	// Выводим данные грузополучателя и покупателя.
	ТекстГрузополучателя = "--";
	
	ПредставлениеГрузополучателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Грузополучатель и его адрес: %1'"),
		ТекстГрузополучателя);
	СтрокаПоДокументу = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='К платежно-расчетному документу № %1'"),
		?(ПустаяСтрока(ДанныеПечати.СтрокаПоДокументу),
			НСтр("ru='-- от --'"),
			ДанныеПечати.СтрокаПоДокументу));
	
	ПараметрыШапки.Вставить("ПоДокументу", СтрокаПоДокументу);
	
	ЕстьГрузополучатель = Не ДанныеПечати.ТолькоУслуги;
	
	ТаблицаКонтрагентов = ТаблицаКонтрагентовСчетаФактуры(ДанныеПечати, ДанныеКонтрагентов);
	
	ПредставлениеПокупателя       = "";
	ПредставлениеАдресаПокупателя = "";
	ПредставлениеИННПокупателя    = "";
	ПредставлениеГрузополучателя  = "";
	
	Для Каждого СтрокаТаблицы Из ТаблицаКонтрагентов Цикл
		
		СведенияОПокупателе = СтрокаТаблицы.СведенияОПокупателе;
		
		ПредставлениеПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1; %2'"),
			ПредставлениеПокупателя,
			ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование", Ложь));
		
		ПредставлениеАдресаПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1; %2'"),
			ПредставлениеАдресаПокупателя,
			ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ЮридическийАдрес", Ложь));
			
		ПредставлениеИННПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1; %2%3'"),
			ПредставлениеИННПокупателя,
			ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ИНН", Ложь),
			?(Не ПустаяСтрока(СтрокаТаблицы.КПП), "/" + СтрокаТаблицы.КПП, ""));
		
		Если ЕстьГрузополучатель Тогда
			СведенияОГрузополучателе = СтрокаТаблицы.СведенияОГрузополучателе;
			ПредставлениеГрузополучателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1; %2'"),
				ПредставлениеГрузополучателя,
				ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, "ПолноеНаименование,ФактическийАдрес", Ложь));
		КонецЕсли;
		
	КонецЦикла;
	
	ПредставлениеПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Покупатель: %1'"),
		Сред(ПредставлениеПокупателя, 3));
	
	ПредставлениеАдресаПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Адрес: %1'"),
		Сред(ПредставлениеАдресаПокупателя, 3));
	
	ПредставлениеИННПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='ИНН/КПП покупателя: %1'"),
		Сред(ПредставлениеИННПокупателя, 3));
		
	ПредставлениеГрузополучателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Грузополучатель и его адрес: %1'"),
		?(ЕстьГрузополучатель, Сред(ПредставлениеГрузополучателя, 3), "--"));
		
	ПараметрыШапки.Вставить("ПредставлениеПокупателя", ПредставлениеПокупателя);
	ПараметрыШапки.Вставить("АдресПокупателя", ПредставлениеАдресаПокупателя);
	ПараметрыШапки.Вставить("ИННПокупателя", ПредставлениеИННПокупателя);
	ПараметрыШапки.Вставить("ПредставлениеГрузополучателя", ПредставлениеГрузополучателя);
	ПараметрыШапки.Вставить("Валюта", НСтр("ru='Валюта: наименование, код Российский рубль, 643'"));
	
	СтруктураПараметровИдентификаторГосКонтракта = Новый Структура("ИдентификаторГосКонтракта");
	ЗаполнитьЗначенияСвойств(СтруктураПараметровИдентификаторГосКонтракта, ДанныеПечати);
	Если ДействуетПостановление981(ДанныеПечати.Дата,ДанныеПечати.ДатаИсправления) Тогда
		ПредставлениеИдентификаторГосКонтракта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Идентификатор государственного контракта, договора (соглашения) (при наличии): %1'"),
			СокрЛП(СтруктураПараметровИдентификаторГосКонтракта.ИдентификаторГосКонтракта));
	Иначе
		ПредставлениеИдентификаторГосКонтракта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Идентификатор государственного контракта, договора (соглашения): %1'"),
			СокрЛП(СтруктураПараметровИдентификаторГосКонтракта.ИдентификаторГосКонтракта));
	КонецЕсли;
	ПараметрыШапки.Вставить("ИдентификаторГосКонтракта", ПредставлениеИдентификаторГосКонтракта);
	
	ОбластьМакета.Параметры.Заполнить(ПараметрыШапки);
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПодвалаУПД(ОбластьПодвала, ДанныеПечати, СведенияОбОрганизации, ДанныеКонтрагентов)
	
	ОбластьПодвала.Параметры.Заполнить(ДанныеПечати);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ФИОРуководителя", ДанныеПечати.Руководитель);
	Если СведенияОбОрганизации.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
		СтруктураПараметров.Вставить("ФИОРуководителяОрганизации", ДанныеПечати.Руководитель);
		СтруктураПараметров.Вставить("ФИОГлавногоБухгалтера", ДанныеПечати.ГлавныйБухгалтер);
	Иначе
		СтруктураПараметров.Вставить("ФИОПБОЮЛ", ДанныеПечати.Руководитель);
		СтруктураПараметров.Вставить("Свидетельство", СведенияОбОрганизации.Свидетельство);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ФИОКладовщика", ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.Кладовщик, ДанныеПечати.Дата));
	СтруктураПараметров.Вставить("ДолжностьКладовщика", ДанныеПечати.ДолжностьКладовщика);
	
	ПолнаяДатаДокумента = СтрЗаменить(Формат(ДанныеПечати.Дата, "ДЛФ=DD"),НСтр("ru = 'г.'"),"");
	ДлинаСтроки = СтрДлина(ПолнаяДатаДокумента);
	ПозицияРазделителя = СтрНайти(ПолнаяДатаДокумента, " ");
	ПредставлениеДаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='""%1"" %2года'"),
		Лев(ПолнаяДатаДокумента, ПозицияРазделителя -1),
		Прав(ПолнаяДатаДокумента, ДлинаСтроки - ПозицияРазделителя));
		
	СтруктураПараметров.Вставить("ДатаДокумента", ПредставлениеДаты);
	
	ИННПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ИНН,", Ложь);
	Если ЗначениеЗаполнено(ДанныеПечати.КПППоставщика) Тогда
		ПредставлениеОрганизации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1, ИНН/КПП %2/%3'"),
			СведенияОбОрганизации.ОфициальноеНаименование,
			ИННПоставщика,
			ДанныеПечати.КПППоставщика);
	ИначеЕсли ЗначениеЗаполнено(ИННПоставщика) Тогда
		ПредставлениеОрганизации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1, ИНН %2'"),
			СведенияОбОрганизации.ОфициальноеНаименование,
			ИННПоставщика);
	Иначе
		ПредставлениеОрганизации = СведенияОбОрганизации.ОфициальноеНаименование;
	КонецЕсли;
	СтруктураПараметров.Вставить("ПредставлениеОрганизации", ПредставлениеОрганизации);
	
	ТаблицаКонтрагентов = ТаблицаКонтрагентовСчетаФактуры(ДанныеПечати, ДанныеКонтрагентов);
	ПредставлениеКонтрагента    = "";
	
	Для Каждого СтрокаТаблицы Из ТаблицаКонтрагентов Цикл
		СведенияОПокупателе = СтрокаТаблицы.СведенияОПокупателе;
		ПолноеНаименование = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование", Ложь);
		ИННПокупателя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ИНН", Ложь);
		Если Не ПустаяСтрока(СтрокаТаблицы.КПП) Тогда
			ПредставлениеКонтрагента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1; %2, ИНН/КПП %3/%4'"),
				ПредставлениеКонтрагента,
				ПолноеНаименование,
				ИННПокупателя,
				СтрокаТаблицы.КПП);
		ИначеЕсли ЗначениеЗаполнено(ИННПокупателя) Тогда
			ПредставлениеКонтрагента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1; %2, ИНН %3'"),
				ПредставлениеКонтрагента,
				ПолноеНаименование,
				ИННПокупателя);
		Иначе
			ПредставлениеКонтрагента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1; %2'"),
				ПредставлениеКонтрагента,
				ПолноеНаименование);
		КонецЕсли;
	
	КонецЦикла;
	СтруктураПараметров.Вставить("ПредставлениеКонтрагента", Сред(ПредставлениеКонтрагента, 3));
	
	Если ЗначениеЗаполнено(ДанныеПечати.ДоверенностьНомер) И ЗначениеЗаполнено(ДанныеПечати.ДоверенностьДата)
		И (ЗначениеЗаполнено(ДанныеПечати.ДоверенностьВыдана) Или ЗначениеЗаполнено(ДанныеПечати.ДоверенностьЛицо)) Тогда
		
		ТекстОснования = СокрЛП(ДанныеПечати.Основание) + "; "
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'по доверенности №%1 от %2, выданной %3 %4'"),
				ДанныеПечати.ДоверенностьНомер,
				Формат(ДанныеПечати.ДоверенностьДата, "ДЛФ=DD"),
				ДанныеПечати.ДоверенностьВыдана,
				ДанныеПечати.ДоверенностьЛицо);
		СтруктураПараметров.Вставить("Основание", ТекстОснования);
		
	КонецЕсли;
	
	ОбластьПодвала.Параметры.Заполнить(СтруктураПараметров);
	
КонецПроцедуры

Процедура ЗаполнитьТабличныйДокументУПД(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати) Экспорт
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	МакетУПД = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОбщихФорм.ПФ_MXL_УниверсальныйПередаточныйДокумент");
	МакетУПД_625 = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОбщихФорм.ПФ_MXL_УниверсальныйПередаточныйДокумент_625");
	МакетУПД_981 = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОбщихФорм.ПФ_MXL_УниверсальныйПередаточныйДокумент981");
	
	ДанныеПечати        = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ДанныеДляПечати.Свойство("РезультатПоКонтрагентам") тогда
		ВыборкаКонтрагентов = ДанныеДляПечати.РезультатПоКонтрагентам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Иначе
		ВыборкаКонтрагентов = Неопределено;
	КонецЕсли;
	Если ДанныеДляПечати.Свойство("РезультатПоИсходнымДанным") Тогда
		ВыборкаОснований = ДанныеДляПечати.РезультатПоИсходнымДанным.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Иначе
		ВыборкаОснований = Неопределено;
	КонецЕсли;
	
	ЕстьПостановление981 = ЛОЖЬ;
	ЕстьПостановление1137_625 = ЛОЖЬ;
	ЕстьПостановление1137 = ЛОЖЬ;
	
	ПервыйДокумент = Истина;
	Пока ДанныеПечати.Следующий() Цикл
		
		Если ДанныеПечати.СтатусУПД = 2
			И ЗначениеЗаполнено(ДанныеПечати.НалогообложениеНДС)
			И ДанныеПечати.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС
			И НЕ ДанныеПечати.ЭтоПередачаНаКомиссию Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 не введен %2'"),
				ДанныеПечати.Ссылка,
				ДанныеПечати.ПредставлениеДокумента);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка,
				,
				"ТекстСчетФактура");
				
			Продолжить;
		КонецЕсли;
		
		Если ДействуетПостановление981(ДанныеПечати.Дата, ДанныеПечати.ДатаИсправления) Тогда
			Макет = МакетУПД_981;
			ЕстьПостановление981 = Истина;
		ИначеЕсли ВедетсяУчетНДСПоФЗ56(ДанныеПечати.Дата, ДанныеПечати.ДатаИсправления) Тогда
			Макет = МакетУПД_625;
			ЕстьПостановление1137_625 = Истина;
		Иначе
			Макет = МакетУПД;
			ЕстьПостановление1137 = Истина;
		КонецЕсли;
		
		Если ЕстьПостановление1137_625 И ЕстьПостановление1137 Тогда
			
			Текст = НСтр("ru = 'Недоступна одновременная печать универсальных передаточных документов,
				|сформированных до и после начала применения постановления Правительства РФ №625 от 25 мая 2017 г.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			
			ТабличныйДокумент.Очистить();
			Прервать;
			
		КонецЕсли;
		
		Если (ЕстьПостановление1137_625 ИЛИ ЕстьПостановление1137) И ЕстьПостановление981 Тогда
			
			Текст = НСтр("ru = 'Недоступна одновременная печать универсальных передаточных документов,
				|сформированных до и после начала применения постановления Правительства РФ №981 от 19 августа 2017 г.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			
			ТабличныйДокумент.Очистить();
			Прервать;
			
		КонецЕсли;
		
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
		// Выводим общие реквизиты шапки
		СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата);
		ЗаполнитьРеквизитыШапкиУПД(ДанныеПечати, СведенияОбОрганизации, ВыборкаКонтрагентов, Макет, ТабличныйДокумент);
		
		// Выводим заголовок таблицы
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
		
		НомерСтраницы = 1;
		
		// Инициализация итогов в документе
		ИтоговыеСуммы = СтруктураИтоговыеСуммы();
		
		// Создаем массив для проверки вывода
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть документа
		ОбластьСтрокаСтандарт = Макет.ПолучитьОбласть("Строка");
		ОбластьИтого = Макет.ПолучитьОбласть("Итого");
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		
		ЗаполнитьРеквизитыПодвалаУПД(ОбластьПодвал, ДанныеПечати, СведенияОбОрганизации, ВыборкаКонтрагентов);
		
		Если ДанныеДляПечати.РезультатПоШапке.Колонки.Найти("ВыводитьКодНоменклатуры") <> Неопределено Тогда
			ВыводитьКодНоменклатуры = ДанныеПечати.ВыводитьКодНоменклатуры;
		Иначе
			ВыводитьКодНоменклатуры = Истина;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска);
			
		ИспользоватьНаборы = Ложь;
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ВыборкаПоДокументам, "ЭтоНабор") Тогда
			ИспользоватьНаборы = Истина;
			ОбластьСтрокаНабор         = Макет.ПолучитьОбласть("СтрокаНабор");
			ОбластьСтрокаКомплектующие = Макет.ПолучитьОбласть("СтрокаКомплектующие");
		КонецЕсли;
		
		ВыводитьКодыТНВЭД = ВыводитьКодыТНВЭД(ДанныеПечати, ЕстьПостановление981);
		
		ОперацияОблагаетсяНДСУПокупателя = Ложь;
		Если ДанныеПечати.СтатусУПД = 1
		И ДанныеПечати.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя Тогда
			ОперацияОблагаетсяНДСУПокупателя = Истина;
		КонецЕсли;
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		КоличествоСтрок = СтрокаТовары.Количество();
		ТолькоСтавкаБезНДС = Истина;
		НомерСтроки = 0;
		Пока СтрокаТовары.Следующий() Цикл
			
			Если ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.ОтчетКомиссионера")
				ИЛИ ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями") Тогда
				Если СтрокаТовары.Покупатель <> ДанныеПечати.Покупатель
					И СтрокаТовары.Покупатель <> НЕОПРЕДЕЛЕНО Тогда
						Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			Если НаборыСервер.ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьСтрока = ОбластьСтрокаНабор;
			ИначеЕсли НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьСтрока = ОбластьСтрокаКомплектующие;
			Иначе
				ОбластьСтрока = ОбластьСтрокаСтандарт;
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				ЗаполнитьРеквизитыСтрокиТовара(СтрокаТовары, ОбластьСтрока, Неопределено, , ВыводитьКодыТНВЭД);
			Иначе
				НомерСтроки = НомерСтроки + 1;
				ЗаполнитьРеквизитыСтрокиТовара(СтрокаТовары, ОбластьСтрока, НомерСтроки, , ВыводитьКодыТНВЭД);
				ПроставитьПрочеркиВПустыеПоляСтроки(ОбластьСтрока);
			КонецЕсли;
			
			СтруктураПараметров = Новый Структура;
			Если ОперацияОблагаетсяНДСУПокупателя Тогда
				СтруктураПараметров.Вставить("СтавкаНДС", НСтр("ru='НДС исчисляется налоговым агентом'"));
				СтруктураПараметров.Вставить("СуммаСНДС", "--");
				ТолькоСтавкаБезНДС = Ложь;
			ИначеЕсли СтрокаТовары.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС Тогда
				СтруктураПараметров.Вставить("СтавкаНДС", НСтр("ru='без НДС'"));
				СтруктураПараметров.Вставить("СуммаНДС", НСтр("ru='без НДС'"));
			ИначеЕсли СтрокаТовары.СтавкаНДС = Перечисления.СтавкиНДС.НДС0 Тогда
				СтруктураПараметров.Вставить("СуммаНДС", 0);
				ТолькоСтавкаБезНДС = Ложь;
			Иначе
				ТолькоСтавкаБезНДС = Ложь;
			КонецЕсли;
			Если Не НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				СтруктураПараметров.Вставить("Акциз", НСтр("ru='без акциза'"));
			КонецЕсли;
			ОбластьСтрока.Параметры.Заполнить(СтруктураПараметров);
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьСтрока);
			
			Если НомерСтроки = КоличествоСтрок Тогда
				МассивВыводимыхОбластей.Добавить(ОбластьИтого);
				МассивВыводимыхОбластей.Добавить(ОбластьПодвал);
			КонецЕсли;
			
			//Если НомерСтроки <> 1 И НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
			//	
			//	НомерСтраницы = НомерСтраницы + 1;
			//	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			//	
			//	ОбластьНумерацияЛистов = Макет.ПолучитьОбласть("НумерацияЛистов");
			//	ОбластьНумерацияЛистов.Параметры.Номер = НомерСчетаФактурыНаПечать(ДанныеПечати.Номер, ДанныеПечати.ИндексПодразделения);
			//	ОбластьНумерацияЛистов.Параметры.Дата = Формат(ДанныеПечати.Дата, "ДЛФ=ДД; ДП=--");
			//	ОбластьНумерацияЛистов.Параметры.НомерСтраницы = НомерСтраницы;
			//	
			//	ТабличныйДокумент.Вывести(ОбластьНумерацияЛистов);
			//	ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
			//	
			//КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
			Если Не НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				РассчитатьИтоговыеСуммы(ИтоговыеСуммы, СтрокаТовары);
			КонецЕсли;
		КонецЦикла;
		// Выводим итоги по документу
		ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, НомерСтроки, ВалютаРегламентированногоУчета);
		
		Если ТолькоСтавкаБезНДС Тогда
			ИтоговыеСуммы.ИтогоСуммаНДС = НСтр("ru='без НДС'");
		КонецЕсли;
		
		Если ОперацияОблагаетсяНДСУПокупателя Тогда
			ИтоговыеСуммы.Вставить("ИтогоСуммаСНДС", "--");
			ИтоговыеСуммы.Вставить("ИтогоСуммаСНДСНаСтранице", "--");
		КонецЕсли;
		
		ОбластьИтого.Параметры.Заполнить(ИтоговыеСуммы);
		ПроставитьПрочеркиВПустыеПоляСтроки(ОбластьИтого);
		ТабличныйДокумент.Вывести(ОбластьИтого);
		
		КоличествоСтраниц = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документ составлен на %1 %2'"),
			НомерСтраницы,
			ОбщегоНазначенияУТКлиентСервер.ФормаМножественногоЧисла(
				НСтр("ru = 'листе'"), НСтр("ru = 'листах'"), НСтр("ru = 'листах'"), НомерСтраницы));
		СтруктураПараметров = Новый Структура("КоличествоСтраниц", КоличествоСтраниц);
		ОбластьПодвал.Параметры.Заполнить(СтруктураПараметров);
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,
			ДанныеПечати.Ссылка);
			
	КонецЦикла;
	
КонецПроцедуры

Функция СведенияОГрузоотправителе(ДанныеПечати)
	
	Если ТипЗнч(ДанныеПечати.Грузоотправитель) = Тип("СправочникСсылка.РегистрацииВНалоговомОргане") Тогда
		СведенияОГрузоотправителе = Справочники.РегистрацииВНалоговомОргане.СведенияОПодразделении(ДанныеПечати.Грузоотправитель, ДанныеПечати.Дата);
	Иначе
		СведенияОГрузоотправителе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, ДанныеПечати.Дата);
	КонецЕсли;
	
	Возврат СведенияОГрузоотправителе;
	
КонецФункции

Функция НомерСчетаФактурыНаПечать(Номер, ИндексПодразделения, УдалитьПользовательскийПрефикс = Ложь)
	
	НомерНаПечать = "";
	
	Если Номер <> Неопределено Тогда
	
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Номер, Ложь, УдалитьПользовательскийПрефикс);
		
		ПозицияРазделителя = СтрНайти(НомерНаПечать, "-");
		Префикс = Лев(НомерНаПечать, ПозицияРазделителя);
		НомерБезПрефикса = Сред(НомерНаПечать, ПозицияРазделителя + 1);
		
		Если Лев(НомерБезПрефикса, 1) = "И" Тогда
			НомерНаПечать = Префикс + Сред(НомерБезПрефикса, 2);
		КонецЕсли;
		Если ЗначениеЗаполнено(ИндексПодразделения) Тогда
			НомерНаПечать = НомерНаПечать + "/" + ИндексПодразделения;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НомерНаПечать;
	
КонецФункции

Функция ТаблицаКонтрагентовСчетаФактуры(ДанныеПечати, ДанныеКонтрагентов)
	
	ТаблицаКонтрагентов = Новый ТаблицаЗначений;
	ТаблицаКонтрагентов.Колонки.Добавить("СведенияОПокупателе");
	ТаблицаКонтрагентов.Колонки.Добавить("СведенияОГрузополучателе");
	ТаблицаКонтрагентов.Колонки.Добавить("КПП");
	ТаблицаКонтрагентов.Колонки.Добавить("ИНН");
	
	Если ДанныеКонтрагентов <> Неопределено Тогда
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ДанныеКонтрагентов.НайтиСледующий(СтруктураПоиска);
		ВыборкаКонтрагентов = ДанныеКонтрагентов.Выбрать();
		
		Пока ВыборкаКонтрагентов.Следующий() Цикл
			
			СтрокаКонтрагента = ТаблицаКонтрагентов.Добавить();
			СтрокаКонтрагента.СведенияОПокупателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(
				ВыборкаКонтрагентов.Контрагент, ДанныеПечати.Дата);
			СтрокаКонтрагента.СведенияОГрузополучателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(
				ВыборкаКонтрагентов.Грузополучатель, ДанныеПечати.Дата);
				
			Если ПустаяСтрока(ВыборкаКонтрагентов.КПППокупателя) Тогда
				СтрокаКонтрагента.КПП = СтрокаКонтрагента.СведенияОПокупателе.КПП
			Иначе
				СтрокаКонтрагента.КПП = ВыборкаКонтрагентов.КПППокупателя;
			КонецЕсли;
			
			СтрокаКонтрагента.ИНН = ВыборкаКонтрагентов.ИННПокупателя;
			
		КонецЦикла;
		
	Иначе
		
		СтрокаКонтрагента = ТаблицаКонтрагентов.Добавить();
		СтрокаКонтрагента.СведенияОПокупателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(
			ДанныеПечати.Контрагент, ДанныеПечати.Дата);
		СтрокаКонтрагента.СведенияОГрузополучателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(
			ДанныеПечати.Грузополучатель, ДанныеПечати.Дата);
		Если ПустаяСтрока(ДанныеПечати.КПППокупателя) Тогда
			СтрокаКонтрагента.КПП = СтрокаКонтрагента.СведенияОПокупателе.КПП
		Иначе
			СтрокаКонтрагента.КПП = ДанныеПечати.КПППокупателя;
		КонецЕсли;
		СтрокаКонтрагента.ИНН = ДанныеПечати.ИННПокупателя;
		
	КонецЕсли;
	
	Возврат ТаблицаКонтрагентов;
	
КонецФункции

Функция ДействуетПостановление981(ДатаДокумента, ДатаИсправления)
	
	НачалоПрименения = '20171001';
	
	Дата = ?(ЗначениеЗаполнено(ДатаИсправления),ДатаИсправления,ДатаДокумента);
	
	Если Дата < НачалоПрименения Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция ВыводитьКодыТНВЭД(ДанныеПечати, ДействуетПостановление981)
	ПараметрыВывода = Новый Структура("ВыводитьВСтроке, ВыводитьВКолонке");
	
	ПараметрыВывода.ВыводитьВСтроке = ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.СчетФактураВыданный")
		И УчетНДСУТ.СтранаЯвляетсяЧленомЕАЭС(ДанныеПечати.СтранаРегистрации, ДанныеПечати.Дата)
		И ДанныеПечати.Дата >= УчетНДСУТ.ДатаНачалаДействия150ФЗ();
	ПараметрыВывода.ВыводитьВКолонке = ПараметрыВывода.ВыводитьВСтроке И ДействуетПостановление981;
	
	Возврат ПараметрыВывода
	
КонецФункции

Функция ВедетсяУчетНДСПоФЗ56(ДатаДокумента, ДатаИсправления)
	
	НачалоПримененияФЗ56 = '20170701';
	
	Дата = ?(ЗначениеЗаполнено(ДатаИсправления),ДатаИсправления,ДатаДокумента);
	
	Если Дата < НачалоПримененияФЗ56 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция СтруктураИтоговыеСуммы()
	
	Структура = Новый Структура;
	
	СтруктураРесурсовДляИтогов = СтруктураРесурсовДляИтогов();
	
	Для Каждого Элемент Из СтруктураРесурсовДляИтогов Цикл
		Структура.Вставить("Итого"+Элемент.Ключ+"НаСтранице", 0);
		Структура.Вставить("Итого"+Элемент.Ключ, 0);
	КонецЦикла;
	
	Возврат Структура;
	
КонецФункции

Процедура ЗаполнитьРеквизитыСтрокиТовара(СтрокаТовары, ОбластьМакета, НомерСтроки, ВыводитьКодНоменклатуры = Истина, ВыводитьКодТНВД = Неопределено, СчетФактураНаАванс = Ложь)
	
	ИспользоватьНаборы = ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТовары, "ЭтоНабор");
	
	ПрефиксИПостфикс = НаборыСервер.ПолучитьПрефиксИПостфикс(СтрокаТовары, ИспользоватьНаборы);
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоКомплектующие
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие
		И (СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям
		   ИЛИ СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам) Тогда
		// Область должна остаться незаполненной
		ОбластьМакета.Параметры.Заполнить(НаборыСервер.ПустыеДанные());
	ИначеЕсли ИспользоватьНаборы
		И СтрокаТовары.ЭтоНабор
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие
		И (СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих
			ИЛИ СчетФактураНаАванс) Тогда
		// Область должна остаться незаполненной
		ОбластьМакета.Параметры.Заполнить(НаборыСервер.ПустыеДанные());
	Иначе
		ОбластьМакета.Параметры.Заполнить(СтрокаТовары);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("КоличествоМест, КоличествоВОдномМесте, НоменклатураКод,КодТНВЭД", 0, 0, "", "--");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтрокаТовары);
	ОкруглитьДоЦелого(СтруктураПараметров.КоличествоМест);
	СтруктураПараметров.Вставить("НомерСтроки", НомерСтроки);
	
	ДополнительныеПараметрыПолученияНаименованияДляПечати = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
	ДополнительныеПараметрыПолученияНаименованияДляПечати.ВозвратнаяТара = СтрокаТовары.ЭтоВозвратнаяТара;	
	Если ВыводитьКодТНВД <> Неопределено Тогда
		ДополнительныеПараметрыПолученияНаименованияДляПечати.КодТНВЭД = ?(НЕ ВыводитьКодТНВД.ВыводитьВКолонке И ВыводитьКодТНВД.ВыводитьВСтроке, СтрокаТовары.КодТНВЭД, "");
		Если НЕ ВыводитьКодТНВД.ВыводитьВКолонке Тогда
			СтруктураПараметров.КодТНВЭД = "--";
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеНоменклатуры =  ПрефиксИПостфикс.Префикс
		+ НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
			Строка(СтрокаТовары.НоменклатураНаименование),
			СтрокаТовары.ХарактеристикаНаименование,
			,
			,
			ДополнительныеПараметрыПолученияНаименованияДляПечати)
		+ ПрефиксИПостфикс.Постфикс;
	
	СтруктураПараметров.Вставить("ПредставлениеНоменклатуры", ПредставлениеНоменклатуры);
		
	Если Не ВыводитьКодНоменклатуры Тогда
		СтруктураПараметров.НоменклатураКод = "";
	КонецЕсли;
	ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
	
КонецПроцедуры

Процедура ПроставитьПрочеркиВПустыеПоляСтроки(ОбластьМакета)

	Для Сч = 0 По ОбластьМакета.Параметры.Количество() - 1 Цикл
		
		ТекПараметр = ОбластьМакета.Параметры.Получить(Сч);
		
		Если НЕ ЗначениеЗаполнено(ТекПараметр) Тогда
			ОбластьМакета.Параметры.Установить(Сч, "--");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура РассчитатьИтоговыеСуммы(ИтоговыеСуммы, СтрокаТовары)
	
	СтруктураСуммПоСтроке = СтруктураРесурсовДляИтогов();
	
	ЗаполнитьЗначенияСвойств(СтруктураСуммПоСтроке, СтрокаТовары);
	ОкруглитьДоЦелого(СтруктураСуммПоСтроке.КоличествоМест);
	Для Каждого Элемент Из СтруктураСуммПоСтроке Цикл
		Если ЗначениеЗаполнено(Элемент.Значение) Тогда
			ИтоговыеСуммы["Итого"+Элемент.Ключ+"НаСтранице"] = ИтоговыеСуммы["Итого"+Элемент.Ключ+"НаСтранице"] + Элемент.Значение;
			ИтоговыеСуммы["Итого"+Элемент.Ключ] = ИтоговыеСуммы["Итого"+Элемент.Ключ] + Элемент.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, ВсегоНомеров, ВалютаРегламентированногоУчета)
	
	ИтоговыеСуммы.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", ЧислоПрописью(ВсегоНомеров, ,",,,,,,,,0"));
	ИтоговыеСуммы.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоСуммаСНДС, ВалютаРегламентированногоУчета));
	
КонецПроцедуры

Функция СтруктураРесурсовДляИтогов()
	
	Структура = Новый Структура;
	
	Структура.Вставить("СуммаБезНДС",       0);
	Структура.Вставить("СуммаНДС",          0);
	Структура.Вставить("СуммаСНДС",         0);
	Структура.Вставить("Количество",        0);
	Структура.Вставить("КоличествоМест",    0);
	Структура.Вставить("КоличествоПринято", 0);
	Структура.Вставить("МассаБрутто",       0);
	Структура.Вставить("МассаНетто",        0);
	Структура.Вставить("Сумма",             0);
	
	Структура.Вставить("РазницаБезНДСУвеличение", 0);
	Структура.Вставить("РазницаБезНДСУменьшение", 0);
	Структура.Вставить("РазницаНДСУвеличение",    0);
	Структура.Вставить("РазницаНДСУменьшение",    0);
	Структура.Вставить("РазницаСНДСУвеличение",   0);
	Структура.Вставить("РазницаСНДСУменьшение",   0);
	
	Возврат Структура;
	
КонецФункции

Процедура ОкруглитьДоЦелого(ОкругляемоеЧисло)
	Если ЗначениеЗаполнено(ОкругляемоеЧисло) Тогда
		Если ОкругляемоеЧисло <> Цел(ОкругляемоеЧисло) Тогда
			ОкругляемоеЧисло = Цел(ОкругляемоеЧисло) + 1;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
