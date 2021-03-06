﻿
&После("Печать")
Процедура ВЦБП_Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	ПодходящиеОбъекты = Новый Массив;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ТрудовойДоговор_Янтарь") Тогда
		//ИЛИ УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ТрудовойДоговорПриДистанционнойРаботе") Тогда
		
		Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ТрудовойДоговор_Янтарь") Тогда
			ИмяМакета = "ПФ_MXL_ТрудовойДоговор_Янтарь";
			Представление = НСтр("ru='Трудовой договор'");
		Иначе
			ИмяМакета = "ПФ_MXL_ТрудовойДоговорПриДистанционнойРаботе";
			Представление = НСтр("ru='Трудовой договор при дистанционной работе'");
		КонецЕсли;
		
		ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		ИмяМакета, Представление,
		ТабличныйДокументТрудовойДоговорЯнтарь(
		ИмяМакета,
		МассивОбъектов,
		ОбъектыПечати,
		ПараметрыВывода),
		,
		"Обработка.ПечатьКадровыхПриказовРасширенная." + ИмяМакета);
		ОценкаПроизводительности.ЗакончитьЗамерВремени("ОтчетТрудовойДоговорФормирование", ВремяНачалаЗамера);
	КонецЕсли;
	
КонецПроцедуры

Функция ТабличныйДокументТрудовойДоговорЯнтарь(ИмяМакета, МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьКадровыхПриказовРасширенная." + ИмяМакета);
	
	ДокументРезультат = Новый ТабличныйДокумент;
	НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
	
	ДокументРезультат.КлючПараметровПечати = "ПараметрыПечати_ТрудовойДоговор";
	ДокументРезультат.ПолеСлева = 25;
	ДокументРезультат.ПолеСверху = 10;
	ДокументРезультат.ПолеСправа = 10;
	ДокументРезультат.ПолеСнизу = 10;
	
	ДанныеДляПечати = ДанныеДляПечатиТрудовогоДоговораЯнтарь(МассивОбъектов, ИмяМакета);
	
	ПервыйПриказ = Истина;
	Для Каждого ОписаниеПараметров Из ДанныеДляПечати Цикл
		
		МассивДанныхЗаполнения = ОписаниеПараметров.Значение;
		НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
		
		Для каждого ПараметрыМакета Из МассивДанныхЗаполнения Цикл
			
			Если МассивОбъектов.Количество() = 1
				И ЗначениеЗаполнено(ПараметрыМакета.EMail) Тогда
				
				ПараметрыВывода.ПараметрыОтправки.Получатель = ПараметрыМакета.EMail;
				ПараметрыВывода.ПараметрыОтправки.Тема = НСтр("ru='Трудовой договор'");
				
				Если ЗначениеЗаполнено(ПараметрыМакета.ТрудовойДоговорНомер) Тогда
					ПараметрыВывода.ПараметрыОтправки.Тема = ПараметрыВывода.ПараметрыОтправки.Тема + " №" + ПараметрыМакета.ТрудовойДоговорНомер;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ПараметрыМакета.ТрудовойДоговорДата) Тогда
					
					ПараметрыВывода.ПараметрыОтправки.Тема = ПараметрыВывода.ПараметрыОтправки.Тема
					+ " " + НСтр("ru='от'") + " " + ПараметрыМакета.ТрудовойДоговорДата;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если Не ПервыйПриказ Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			Иначе
				ПервыйПриказ = Ложь;
			КонецЕсли;
			
			ДоговорСВодителем = ПараметрыМакета.ДоговорСВодителем;
			ДоговорИТР = ПараметрыМакета.ДоговорИТР;
			ДоговорСКочегаром = ПараметрыМакета.ДоговорСКочегаром;
			//ОбластьЧасть10 = Макет.ПолучитьОбласть("Область1");
			//ОбластьЧасть10.Параметры.Заполнить(ПараметрыМакета);
			//ДокументРезультат.Вывести(ОбластьЧасть10);
			
			
			
			ОбластьШапкаДоговора = Макет.ПолучитьОбласть("ШапкаДоговора");
			ОбластьШапкаДоговора.Параметры.Заполнить(ПараметрыМакета);
			ДокументРезультат.Вывести(ОбластьШапкаДоговора);
			Если ДоговорИТР Тогда
				
				ОбластьПредметДоговора = Макет.ПолучитьОбласть("ПредметДоговораИТР");
				ОбластьПредметДоговора.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьПредметДоговора);
				
				ОбластьСрокДействияДоговора = Макет.ПолучитьОбласть("СрокДействияДоговораИТР");
				ОбластьСрокДействияДоговора.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьСрокДействияДоговора);
				
				ОбластьУсловияОплатыТруда = Макет.ПолучитьОбласть("УсловияДоговораИТР");
				ОбластьУсловияОплатыТруда.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьУсловияОплатыТруда);
				
				ОбластьРежимРабочегоВремени = Макет.ПолучитьОбласть("РежимРабочегоВремениИТР");
				ОбластьРежимРабочегоВремени.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьРежимРабочегоВремени);
				
				ОбластьПраваОбязанностиРаботника = Макет.ПолучитьОбласть("ПраваОбязанностиРаботникаИТР");
				ОбластьПраваОбязанностиРаботника.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьПраваОбязанностиРаботника);
				
				ОбластьПраваОбязанностиРаботодателя = Макет.ПолучитьОбласть("ПраваОбязанностиРаботодателяИТР");
				ОбластьПраваОбязанностиРаботодателя.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьПраваОбязанностиРаботодателя);
				
				ОбластьСоцСтрахование = Макет.ПолучитьОбласть("СоцСтрахованиеИТР");
				ОбластьСоцСтрахование.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьСоцСтрахование);
				
				ОбластьГарантии = Макет.ПолучитьОбласть("ГарантииИТР");
				ДокументРезультат.Вывести(ОбластьГарантии);
				
				ОбластьОтветственностьСторон = Макет.ПолучитьОбласть("ОтветственностьСторонИТР");
				ДокументРезультат.Вывести(ОбластьОтветственностьСторон);
				
				ОбластьПрекращениеДоговора = Макет.ПолучитьОбласть("ПрекращениеДоговораИТР");
				ДокументРезультат.Вывести(ОбластьПрекращениеДоговора);
				
				ОбластьЗаключительныеПоложения = Макет.ПолучитьОбласть("ЗаключениеИТР");
				ДокументРезультат.Вывести(ОбластьЗаключительныеПоложения);
				
			Иначе
				Если ДоговорСВодителем Тогда
					
					ОбластьПункт1 = Макет.ПолучитьОбласть("Пункт1Водитель");
					ОбластьПункт2 = Макет.ПолучитьОбласть("Пункт2Водитель");
					
				Иначе
					
					ОбластьПункт1 = Макет.ПолучитьОбласть("Пункт1");
					ОбластьПункт2 = Макет.ПолучитьОбласть("Пункт2");
					
				КонецЕсли; 
				
				ОбластьПункт1.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьПункт1);
				
				ОбластьПункт2.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьПункт2);
				
				ОбластьПункт3и4 = Макет.ПолучитьОбласть("Пункт3и4");
				ОбластьПункт3и4.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьПункт3и4);
				
				ОбластьПункт5 = Макет.ПолучитьОбласть("Пункт5");
				ОбластьПункт5.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьПункт5);
				
				ОбластьПункт6789 = Макет.ПолучитьОбласть("Пункт6789");
				ОбластьПункт6789.Параметры.Заполнить(ПараметрыМакета);
				ДокументРезультат.Вывести(ОбластьПункт6789);
				
				Если ДоговорСВодителем ИЛИ ДоговорСКочегаром Тогда
					
					ОбластьПункт10 = Макет.ПолучитьОбласть("Пункт10");
					ОбластьПункт10.Параметры.Заполнить(ПараметрыМакета);
					ДокументРезультат.Вывести(ОбластьПункт10);
					
					ОбластьОкончаниеДоговораСПунктом10 = Макет.ПолучитьОбласть("ОкончаниеДоговораСПунктом10");
					ОбластьОкончаниеДоговораСПунктом10.Параметры.Заполнить(ПараметрыМакета);
					ДокументРезультат.Вывести(ОбластьОкончаниеДоговораСПунктом10);
					
				Иначе
					
					ОбластьОкончаниеДоговораБезПункта10 = Макет.ПолучитьОбласть("ОкончаниеДоговораБезПункта10");
					ОбластьОкончаниеДоговораБезПункта10.Параметры.Заполнить(ПараметрыМакета);
					ДокументРезультат.Вывести(ОбластьОкончаниеДоговораБезПункта10);
					
				КонецЕсли;
				
				
			КонецЕсли;
			ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
			ОбластьПодписи.Параметры.Заполнить(ПараметрыМакета);
			ДокументРезультат.Вывести(ОбластьПодписи);
			
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НомерСтрокиНачало, ОбъектыПечати, ОписаниеПараметров.Ключ);
		
	КонецЦикла;
	
	
	Возврат ДокументРезультат;
	
КонецФункции

Функция ДанныеДляПечатиТрудовогоДоговораЯнтарь(МассивОбъектов, ИмяМакета)
	//TODO	
	ДанныеДляПечати = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПриемНаРаботу.Номер КАК ПриказОПриемеНомер,
	|	ПриемНаРаботу.Дата КАК ПриказОПриемеДата,
	|	ПриемНаРаботу.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
	|	ПриемНаРаботу.Организация.НаименованиеСокращенное КАК ОрганизацияНаименованиеСокращенное,
	|	ПриемНаРаботу.Сотрудник,
	|	ПриемНаРаботу.Должность,
	|	ПриемНаРаботу.Подразделение,
	|	ПриемНаРаботу.ВидЗанятости,
	|	ПриемНаРаботу.ТрудовойДоговорНомер,
	|	ПриемНаРаботу.ТрудовойДоговорДата,
	|	ПриемНаРаботу.Руководитель,
	|	ПриемНаРаботу.ДолжностьРуководителя,
	|	ПриемНаРаботу.ДатаПриема,
	|	ПриемНаРаботу.Ссылка,
	|	ПриемНаРаботу.Организация,
	|	ПриемНаРаботу.ДатаЗавершенияТрудовогоДоговора,
	|	ПриемНаРаботу.РазрешениеНаРаботу,
	|	ПриемНаРаботу.РазрешениеНаПроживание,
	|	ПриемНаРаботу.УсловияОказанияМедпомощи,
	|	ПриемНаРаботу.ОснованиеПредставителяНанимателя,
	|	ПриемНаРаботу.ОборудованиеРабочегоМеста,
	|	ПриемНаРаботу.ИныеУсловияДоговора
	|ПОМЕСТИТЬ ВТДанныеПриказаОПриеме
	|ИЗ
	|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
	|ГДЕ
	|	ПриемНаРаботу.Ссылка В(&МассивОбъектов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПриемНаРаботуСпискомСотрудники.Ссылка.Номер,
	|	ПриемНаРаботуСпискомСотрудники.Ссылка.Дата,
	|	ПриемНаРаботуСпискомСотрудники.Ссылка.Организация.НаименованиеПолное,
	|	ПриемНаРаботуСпискомСотрудники.Ссылка.Организация.НаименованиеСокращенное,
	|	ПриемНаРаботуСпискомСотрудники.Сотрудник,
	|	ПриемНаРаботуСпискомСотрудники.Должность,
	|	ПриемНаРаботуСпискомСотрудники.Подразделение,
	|	ПриемНаРаботуСпискомСотрудники.ВидЗанятости,
	|	ПриемНаРаботуСпискомСотрудники.ТрудовойДоговорНомер,
	|	ПриемНаРаботуСпискомСотрудники.ТрудовойДоговорДата,
	|	ПриемНаРаботуСпискомСотрудники.Ссылка.Руководитель,
	|	ПриемНаРаботуСпискомСотрудники.Ссылка.ДолжностьРуководителя,
	|	ПриемНаРаботуСпискомСотрудники.ДатаПриема,
	|	ПриемНаРаботуСпискомСотрудники.Ссылка,
	|	ПриемНаРаботуСпискомСотрудники.Ссылка.Организация,
	|	ПриемНаРаботуСпискомСотрудники.ДатаЗавершенияТрудовогоДоговора,
	|	ПриемНаРаботуСпискомСотрудники.РазрешениеНаРаботу,
	|	ПриемНаРаботуСпискомСотрудники.РазрешениеНаПроживание,
	|	ПриемНаРаботуСпискомСотрудники.УсловияОказанияМедпомощи,
	|	ПриемНаРаботуСпискомСотрудники.Ссылка.ОснованиеПредставителяНанимателя,
	|	ПриемНаРаботуСпискомСотрудники.ОборудованиеРабочегоМеста,
	|	ПриемНаРаботуСпискомСотрудники.ИныеУсловияДоговора
	|ИЗ
	|	Документ.ПриемНаРаботуСписком.Сотрудники КАК ПриемНаРаботуСпискомСотрудники
	|ГДЕ
	|	ПриемНаРаботуСпискомСотрудники.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ДанныеПриказаОПриеме.Сотрудник,
	|	ДанныеПриказаОПриеме.ДатаПриема КАК Период
	|ПОМЕСТИТЬ ВТСотрудникиПериоды
	|ИЗ
	|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеПриказаОПриеме.Руководитель КАК ФизическоеЛицо,
	|	ДанныеПриказаОПриеме.ДатаПриема КАК Период
	|ПОМЕСТИТЬ ВТФизическиеЛицаПериоды
	|ИЗ
	|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме";
	
	Запрос.Выполнить();
	
	// Получение кадровых данных сотрудника.
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
	Запрос.МенеджерВременныхТаблиц,
	"ВТСотрудникиПериоды");
	КадровыеДанные = "ФИОПолные,ФамилияИО,АдресПоПропискеПредставление,ДокументПредставление,Пол,Страна,КоличествоДнейОтпускаОбщее,КлассУсловийТруда,EMailПредставление";
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, КадровыеДанные);
	
	// Получение ФИО руководителей.
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
	Запрос.МенеджерВременныхТаблиц,
	"ВТФизическиеЛицаПериоды");
	КадровыеДанные = "ФИОПолные,ФамилияИО,Пол";
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, КадровыеДанные);
	
	ТаблицаНачислений = КадровыйУчет.ТаблицаНачисленийСотрудниковПоВременнойТаблице(Запрос.МенеджерВременныхТаблиц, "ВТСотрудникиПериоды", , , , Ложь, Истина);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеПриказаОПриеме.Организация,
	|	ДанныеПриказаОПриеме.ПриказОПриемеДата КАК Период
	|ИЗ
	|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме";
	
	СведенияОбОрганизациях = Новый ТаблицаЗначений;
	СведенияОбОрганизациях.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	СведенияОбОрганизациях.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	СведенияОбОрганизациях.Колонки.Добавить("НаименованиеПолное", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ИНН", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("КПП", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ТелефонОрганизации", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ФаксОрганизации", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("АдресЮридический", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("АдресФактический", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ОрганизацияГородФактическогоАдреса", Новый ОписаниеТипов("Строка"));
	
	РезультатЗапросаПоШапке = Запрос.Выполнить();
	
	АдресаОрганизаций = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресаОрганизаций(РезультатЗапросаПоШапке.Выгрузить().ВыгрузитьКолонку("Организация"));
	
	Выборка = РезультатЗапросаПоШапке.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрокаСведенияОбОрганизациях = СведенияОбОрганизациях.Добавить();
		
		Сведения = Новый СписокЗначений;
		Сведения.Добавить("", "НаимЮЛПол");
		Сведения.Добавить("", "ИННЮЛ");
		Сведения.Добавить("", "КППЮЛ");
		Сведения.Добавить("", "ТелОрганизации");
		Сведения.Добавить("", "ФаксОрганизации");
		
		УстановитьПривилегированныйРежим(Истина);
		ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Выборка.Организация, Выборка.Период, Сведения);
		УстановитьПривилегированныйРежим(Ложь);
		
		НоваяСтрокаСведенияОбОрганизациях.Организация = Выборка.Организация;
		НоваяСтрокаСведенияОбОрганизациях.Период = Выборка.Период;
		НоваяСтрокаСведенияОбОрганизациях.НаименованиеПолное = ОргСведения.НаимЮЛПол;
		НоваяСтрокаСведенияОбОрганизациях.ИНН = ОргСведения.ИННЮЛ;
		НоваяСтрокаСведенияОбОрганизациях.КПП = ОргСведения.КППЮЛ;
		НоваяСтрокаСведенияОбОрганизациях.ТелефонОрганизации = ОргСведения.ТелОрганизации;
		НоваяСтрокаСведенияОбОрганизациях.ФаксОрганизации = ОргСведения.ФаксОрганизации;
		
		ОписаниеЮридическогоАдреса = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресОрганизации(
		АдресаОрганизаций,
		Выборка.Организация,
		Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
		НоваяСтрокаСведенияОбОрганизациях.АдресЮридический = ОписаниеЮридическогоАдреса.Представление;
		
		ОписаниеФактическогоАдреса = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресОрганизации(
		АдресаОрганизаций,
		Выборка.Организация,
		Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
		НоваяСтрокаСведенияОбОрганизациях.АдресФактический = ОписаниеФактическогоАдреса.Представление;
		НоваяСтрокаСведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса = ОписаниеФактическогоАдреса.Город;
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("СведенияОбОрганизациях", СведенияОбОрганизациях);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СведенияОбОрганизациях.Период,
	|	СведенияОбОрганизациях.Организация,
	|	СведенияОбОрганизациях.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
	|	СведенияОбОрганизациях.ИНН КАК ИНН,
	|	СведенияОбОрганизациях.КПП КАК КПП,
	|	СведенияОбОрганизациях.ТелефонОрганизации КАК ТелефонОрганизации,
	|	СведенияОбОрганизациях.ФаксОрганизации КАК ФаксОрганизации,
	|	СведенияОбОрганизациях.АдресЮридический КАК ОрганизацияАдресЮридический,
	|	СведенияОбОрганизациях.АдресФактический КАК ОрганизацияАдресФактический,
	|	СведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса КАК ОрганизацияГородФактическогоАдреса
	|ПОМЕСТИТЬ ВТДанныеОрганизаций
	|ИЗ
	|	&СведенияОбОрганизациях КАК СведенияОбОрганизациях
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДолжностиДополнительныеРеквизиты.Значение КАК КатегорияДолжности,
	|	ДолжностиДополнительныеРеквизиты.Ссылка КАК Должность
	|ПОМЕСТИТЬ ВТ_КатегорииДолжностей
	|ИЗ
	|	Справочник.Должности.ДополнительныеРеквизиты КАК ДолжностиДополнительныеРеквизиты
	|ГДЕ
	|	ДолжностиДополнительныеРеквизиты.Свойство.Наименование ПОДОБНО ""%Янтарь_КатегорияДолжности%""
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПриказаОПриеме.Ссылка,
	|	ДанныеПриказаОПриеме.ПриказОПриемеНомер,
	|	ДанныеПриказаОПриеме.ПриказОПриемеДата,
	|	ДанныеПриказаОПриеме.Подразделение,
	|	ДанныеПриказаОПриеме.Должность,
	|	ДанныеПриказаОПриеме.Сотрудник,
	|	ДанныеПриказаОПриеме.ВидЗанятости,
	|	ДанныеПриказаОПриеме.ТрудовойДоговорНомер,
	|	ДанныеПриказаОПриеме.ТрудовойДоговорДата,
	|	ДанныеПриказаОПриеме.ДолжностьРуководителя КАК РуководительДолжность,
	|	ДанныеПриказаОПриеме.ДатаПриема,
	|	ДанныеПриказаОПриеме.ДатаЗавершенияТрудовогоДоговора,
	|	ВЫБОР
	|		КОГДА КадровыеДанныеСотрудников.Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|			ТОГДА """"
	|		ИНАЧЕ ДанныеПриказаОПриеме.РазрешениеНаРаботу
	|	КОНЕЦ КАК РазрешениеНаРаботу,
	|	ВЫБОР
	|		КОГДА КадровыеДанныеСотрудников.Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|			ТОГДА """"
	|		ИНАЧЕ ДанныеПриказаОПриеме.РазрешениеНаПроживание
	|	КОНЕЦ КАК РазрешениеНаПроживание,
	|	ВЫБОР
	|		КОГДА КадровыеДанныеСотрудников.Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|			ТОГДА """"
	|		ИНАЧЕ ДанныеПриказаОПриеме.УсловияОказанияМедпомощи
	|	КОНЕЦ КАК УсловияОказанияМедпомощи,
	|	ДанныеПриказаОПриеме.ОснованиеПредставителяНанимателя,
	|	ДанныеПриказаОПриеме.ОборудованиеРабочегоМеста,
	|	ДанныеПриказаОПриеме.ИныеУсловияДоговора,
	|	ДанныеОрганизаций.Организация,
	|	ДанныеОрганизаций.ОрганизацияНаименованиеПолное,
	|	ДанныеОрганизаций.ИНН,
	|	ДанныеОрганизаций.КПП,
	|	ДанныеОрганизаций.ТелефонОрганизации,
	|	ДанныеОрганизаций.ФаксОрганизации,
	|	ДанныеОрганизаций.ОрганизацияАдресЮридический,
	|	ДанныеОрганизаций.ОрганизацияАдресФактический,
	|	ДанныеОрганизаций.ОрганизацияГородФактическогоАдреса,
	|	КадровыеДанныеСотрудников.Страна,
	|	КадровыеДанныеФизическихЛиц.ФИОПолные КАК РуководительФИОПолные,
	|	КадровыеДанныеФизическихЛиц.ФамилияИО КАК РуководительФамилияИО,
	|	КадровыеДанныеФизическихЛиц.Пол КАК РуководительПол,
	|	КадровыеДанныеСотрудников.ФИОПолные КАК ФИОПолные,
	|	КадровыеДанныеСотрудников.ФамилияИО КАК ФамилияИО,
	|	КадровыеДанныеСотрудников.Пол КАК Пол,
	|	КадровыеДанныеСотрудников.АдресПоПропискеПредставление КАК АдресПоПропискеПредставление,
	|	КадровыеДанныеСотрудников.ДокументПредставление КАК ДокументПредставление,
	|	КадровыеДанныеСотрудников.КоличествоДнейОтпускаОбщее,
	|	КадровыеДанныеСотрудников.КлассУсловийТруда,
	|	КадровыеДанныеСотрудников.EMailПредставление КАК EMail,
	|	ЕСТЬNULL(КатегорииДолжностей.КатегорияДолжности,"""") КАК КатегорияДолжности
	|ИЗ
	|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОрганизаций КАК ДанныеОрганизаций
	|		ПО ДанныеПриказаОПриеме.Организация = ДанныеОрганизаций.Организация
	|			И ДанныеПриказаОПриеме.ПриказОПриемеДата = ДанныеОрганизаций.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
	|		ПО ДанныеПриказаОПриеме.Руководитель = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|			И ДанныеПриказаОПриеме.ДатаПриема = КадровыеДанныеФизическихЛиц.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО ДанныеПриказаОПриеме.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|			И ДанныеПриказаОПриеме.ДатаПриема = КадровыеДанныеСотрудников.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КатегорииДолжностей КАК КатегорииДолжностей
	|		ПО ДанныеПриказаОПриеме.Должность = КатегорииДолжностей.Должность";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДоговорСВодителем = Ложь;
		ДоговорСКочегаром = Ложь;
		ДоговорИТР = Ложь;
		СрочныйДоговор = Ложь;
	 
		КатегорияДолжности = Выборка.КатегорияДолжности;
		
		Если НЕ КатегорияДолжности = "" Тогда
			
		Если КатегорияДолжности.Наименование = "Водитель" Тогда
			
			ДоговорСВодителем = Истина;
		ИначеЕсли КатегорияДолжности.Наименование = "ИТР" Тогда
			
			ДоговорИТР = Истина;
			
		ИначеЕсли КатегорияДолжности.Наименование = "Кочегар" Тогда
			
			ДоговорСКочегаром = Истина;
			
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("не указана категория должности для формирования договора");
		КонецЕсли;
		
		Если Выборка.ДатаЗавершенияТрудовогоДоговора <> Дата( 1,1,1) тогда
			
			СрочныйДоговор = Истина;
			
		КонецЕсли;
		
		ПараметрыТрудовогоДоговора = ПараметрыТрудовогоДоговора();
		ЗаполнитьЗначенияСвойств(ПараметрыТрудовогоДоговора, Выборка);
		
		ПараметрыТрудовогоДоговора.Вставить("ДоговорСВодителем", ДоговорСВодителем);
		ПараметрыТрудовогоДоговора.Вставить("ДоговорИТР", ДоговорИТР);
		ПараметрыТрудовогоДоговора.Вставить("ДоговорСКочегаром", ДоговорСКочегаром);
		
		РезультатСклонения = "";
		Если ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ПараметрыТрудовогоДоговора.РуководительФИОПолные), 2, РезультатСклонения, ПараметрыТрудовогоДоговора.РуководительПол) Тогда
			ПараметрыТрудовогоДоговора.РуководительФИОПолные = РезультатСклонения
		КонецЕсли;
		
		ПараметрыТрудовогоДоговора.РуководительДолжностьВПадеже = СклонениеПредставленийОбъектов.ПросклонятьПредставление(Строка(ПараметрыТрудовогоДоговора.РуководительДолжность), 2);
		ПараметрыТрудовогоДоговора.Вставить("РуководительФИОПолныеВПадеже", СклонениеПредставленийОбъектов.ПросклонятьПредставление(Строка(ПараметрыТрудовогоДоговора.РуководительФИОПолные), 2));
		ПараметрыТрудовогоДоговора.ТрудовойДоговорДата = Формат(Выборка.ТрудовойДоговорДата, "ДЛФ=DD; ДП='""___"" ____________ 20___ г.'");
		ПараметрыТрудовогоДоговора.ПриказОПриемеДата = Формат(Выборка.ПриказОПриемеДата, "ДЛФ=D; ДЛФ=DD");
		ПараметрыТрудовогоДоговора.ДатаПриема = Формат(Выборка.ДатаПриема, "ДЛФ=D; ДЛФ=DD");
		
		Если СрочныйДоговор Тогда
			
			ПараметрыТрудовогоДоговора.ДатаПриема = "С " + 
			Формат(Выборка.ДатаПриема, "ДЛФ=DD") +
			" по " + Формат(Выборка.ДатаЗавершенияТрудовогоДоговора, "ДЛФ=DD");
			
		Иначе
			
			ПараметрыТрудовогоДоговора.ДатаПриема = "С " + 
			Формат(Выборка.ДатаПриема, "ДЛФ=DD");
			
		КонецЕсли; 
		
		ОплатаТруда = "";
		СтрокиНачислений = ТаблицаНачислений.НайтиСтроки(Новый Структура("Сотрудник,Период", Выборка.Сотрудник, Выборка.ДатаПриема));
		Если СтрокиНачислений.Количество() > 0 Тогда
			ОплатаТруда = "должностной оклад (часовая тарифная ставка) в размере ";
			Если Не ПустаяСтрока(СтрокиНачислений[0].ОписаниеОклада) Тогда
				ОплатаТруда = ОплатаТруда + СтрокиНачислений[0].ТарифнаяСтавка + " рублей.";
			КонецЕсли;
			
			//Если ЗначениеЗаполнено(СтрокиНачислений[0].Надбавка) Тогда
			//	ОплатаТруда = ?(ПустаяСтрока(ОплатаТруда), "", ОплатаТруда + "; ") + СтрокиНачислений[0].Надбавка;
			//КонецЕсли;
			
		КонецЕсли;
		
		Если ПустаяСтрока(ОплатаТруда) Тогда
			ОплатаТруда = Символы.ПС + "_____________________________________________________________________________________";
		КонецЕсли;
		
		УсловияОплатыТруда = НСтр("ru='5.1. За выполнение трудовых обязанностей Работнику устанавливается'");
		//Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		//	УсловияОплатыТруда = УсловияОплатыТруда + " " + НСтр("ru='в соответствии со штатным расписанием'");
		//КонецЕсли;
		//
		//УсловияОплатыТруда = УсловияОплатыТруда + ".";
		//
		УсловияОплатыТруда = УсловияОплатыТруда + " " + ОплатаТруда;
		
		
		ПараметрыТрудовогоДоговора.УсловияОплатыТруда = УсловияОплатыТруда;
		
		Если ЗначениеЗаполнено(Выборка.КлассУсловийТруда) Тогда
			
			Если Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Оптимальный Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='оптимальными'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='1 класс'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Допустимый Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='допустимыми'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='2 класс'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный1 Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='во вредных условиях труда по '");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='3 классу, подклассу 3.1 (вредные условия труда 1 степени)'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный2 Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='во вредных условиях труда по '");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='3 классу, подклассу 3.2 (вредные условия труда 2 степени)'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный3 Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='во вредных условиях труда по '");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='3 классу, подклассу 3.3 (вредные условия труда 3 степени)'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный4 Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='во вредных условиях труда по '");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='3 классу, подклассу 3.4 (вредные условия труда 4 степени)'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Опасный Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='опасными'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='4 класс'");
				
			КонецЕсли;
			
		Иначе
			
			ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='в нормальных условиях'");
		КонецЕсли;
		
		ПараметрыТрудовогоДоговора.Вставить("ВидДоговора", "");
		
		Если СрочныйДоговор Тогда
			
			ПараметрыТрудовогоДоговора.ВидДоговора = "СРОЧНЫЙ ТРУДОВОЙ ДОГОВОР";
			
		Иначе
			
			ПараметрыТрудовогоДоговора.ВидДоговора = "ТРУДОВОЙ ДОГОВОР";
			
		КонецЕсли;  
		
		ПараметрыТрудовогоДоговора.Вставить("ГрафикРаботы", "");
		ГрафикРаботы = Выборка.Ссылка.ГрафикРаботы; 
		Если ЗначениеЗаполнено(ГрафикРаботы) Тогда
			
			Если ГрафикРаботы.СпособЗаполнения = Перечисления.СпособыЗаполненияГрафикаРаботы.ПоНеделям Тогда
				
				ПараметрыТрудовогоДоговора.ГрафикРаботы = "";
				
			ИначеЕсли ГрафикРаботы.СпособЗаполнения = Перечисления.СпособыЗаполненияГрафикаРаботы.ПоЦикламПроизвольнойДлины Тогда
				
				ПараметрыТрудовогоДоговора.ГрафикРаботы = "сменный режим работы";
				
			КонецЕсли; 
			
		КонецЕсли; 
		
		ПараметрыТрудовогоДоговора.Вставить("РазрядКатегория", "");
		
		РазрядКатегория = Выборка.Ссылка.РазрядКатегория;
		
		Если ЗначениеЗаполнено(РазрядКатегория) Тогда
			
			ПараметрыТрудовогоДоговора.РазрядКатегория = РазрядКатегория;
			
		КонецЕсли;		
		
		Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.УсловияТруда) Тогда
			
			ПараметрыТрудовогоДоговора.УсловияТруда = "_____________";
			ПараметрыТрудовогоДоговора.КлассУсловий = "_____________";
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ОснованиеПредставителяНанимателя) Тогда
			ПараметрыТрудовогоДоговора.ОснованиеРуководителя = Выборка.ОснованиеПредставителяНанимателя;
		Иначе
			ПараметрыТрудовогоДоговора.ОснованиеРуководителя = "__________________";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ОборудованиеРабочегоМеста) Тогда
			ПараметрыТрудовогоДоговора.ОборудованиеРабочегоМеста = " (" + Выборка.ОборудованиеРабочегоМеста + ")"
		Иначе
			ПараметрыТрудовогоДоговора.ОборудованиеРабочегоМеста = "";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ИныеУсловияДоговора) Тогда
			
			Если ИмяМакета = "ПФ_MXL_ТрудовойДоговорПриДистанционнойРаботе" Тогда
				ПараметрыТрудовогоДоговора.ИныеУсловияДоговора = "8.5.";
			Иначе
				ПараметрыТрудовогоДоговора.ИныеУсловияДоговора = "7.3.";
			КонецЕсли;
			
			ПараметрыТрудовогоДоговора.ИныеУсловияДоговора = ПараметрыТрудовогоДоговора.ИныеУсловияДоговора + " " + Выборка.ИныеУсловияДоговора + ".";
			
		Иначе
			ПараметрыТрудовогоДоговора.ИныеУсловияДоговора = "";
		КонецЕсли;
		
		Если Выборка.ВидЗанятости = Перечисления.ВидыЗанятости.ОсновноеМестоРаботы Тогда
			ПараметрыТрудовогоДоговора.ВидЗанятостиПоДоговору = НСтр("ru='основным местом работы'");
		Иначе
			ПараметрыТрудовогоДоговора.ВидЗанятостиПоДоговору = НСтр("ru='местом работы по совместительству'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ДатаЗавершенияТрудовогоДоговора) Тогда
			
			ПараметрыТрудовогоДоговора.СрокДействияПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='на срок до %1'"),
			Формат(Выборка.ДатаЗавершенияТрудовогоДоговора, "ДЛФ=DD"));
			
			Если Прав(ПараметрыТрудовогоДоговора.СрокДействияПредставление, 1) = "." Тогда
				ПараметрыТрудовогоДоговора.СрокДействияПредставление =
				Лев(ПараметрыТрудовогоДоговора.СрокДействияПредставление, СтрДлина(ПараметрыТрудовогоДоговора.СрокДействияПредставление) - 1);
			КонецЕсли;
			ПараметрыТрудовогоДоговора.СрокДействияПредставление = НСтр("ru='на определенный срок'");
		Иначе
			ПараметрыТрудовогоДоговора.СрокДействияПредставление = НСтр("ru='на неопределенный срок'");
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.КоличествоДнейОтпускаОбщее) Тогда
			ПараметрыТрудовогоДоговора.КоличествоДнейОтпускаОбщее = "____";
		КонецЕсли;
		
		Если ПараметрыТрудовогоДоговора.Страна <> Справочники.СтраныМира.Россия Тогда
			
			Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.РазрешениеНаРаботу) Тогда
				ПараметрыТрудовогоДоговора.РазрешениеНаРаботу = Символы.ПС
				+ "______________________________________________________________________________________";
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.РазрешениеНаПроживание) Тогда
				ПараметрыТрудовогоДоговора.РазрешениеНаПроживание = Символы.ПС
				+ "______________________________________________________________________________________";
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.УсловияОказанияМедпомощи) Тогда
				ПараметрыТрудовогоДоговора.УсловияОказанияМедпомощи = Символы.ПС
				+ "______________________________________________________________________________________";
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.Организация) Тогда
			
			ПараметрыТрудовогоДоговора.ИННКПП =
			НСтр("ru='ИНН'") + ":  " + ?(ЗначениеЗаполнено(Выборка.ИНН), Выборка.ИНН, "_____________");
			
			Если ЗарплатаКадры.ЭтоЮридическоеЛицо(Выборка.Организация) Тогда
				
				ПараметрыТрудовогоДоговора.ИННКПП = ПараметрыТрудовогоДоговора.ИННКПП +
				" " + НСтр("ru='КПП'") + ": " + ?(ЗначениеЗаполнено(Выборка.КПП), Выборка.КПП, "_____________");
				
			КонецЕсли;
			
			ПараметрыТрудовогоДоговора.Вставить("Представлениеорганизации", "");
			
			ПараметрыТрудовогоДоговора.ПредставлениеОрганизации = Выборка.Организация.НаименованиеСокращенное +
			" Адрес: " + Выборка.ОрганизацияАдресЮридический + 
			" т. " + Выборка.ТелефонОрганизации + 
			" ИНН: " + Выборка.ИНН + 
			" КПП: " + Выборка.КПП;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Выборка.РуководительДолжность) Тогда
			ПараметрыТрудовогоДоговора.РуководительДолжность = "__________________________";
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Выборка.РуководительФамилияИО) Тогда
			ПараметрыТрудовогоДоговора.РуководительФамилияИО = "__________________________";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ТелефонОрганизации) Тогда
			ПараметрыТрудовогоДоговора.ОрганизацияТелефон = Выборка.ТелефонОрганизации;
		Иначе
			ПараметрыТрудовогоДоговора.ОрганизацияТелефон = "__________________________";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ФаксОрганизации) Тогда
			
			ПараметрыТрудовогоДоговора.ОрганизацияТелефон = ПараметрыТрудовогоДоговора.ОрганизацияТелефон +
			" " + НСтр("ru='Факс'") + ": " + Выборка.ФаксОрганизации;
			
		КонецЕсли;
		
		ПараметрыТрудовогоДоговора.Вставить("ДнейВредногоОтпуска", "");
		ПараметрыТрудовогоДоговора.Вставить("ДнейНенормированногоОтпуска", "");
		ЕжегодныеОтпуска = Выборка.Ссылка.ЕжегодныеОтпуска;
		ДнейВредногоОтпуска = "";
		ДнейНенормированногоОтпуска = "";
		Для каждого СтрокаОтпуска Из ЕжегодныеОтпуска Цикл
			
			Если СтрокаОтпуска.ВидЕжегодногоОтпуска = Справочники.ВидыОтпусков.ОтпускЗаВредность Тогда
				
				ДнейВредногоОтпуска = СокрЛП(СтрокаОтпуска.КоличествоДнейВГод) + " календарных дней";
				
				Если СрочныйДоговор Тогда
					
					ДнейВредногоОтпуска = ДнейВредногоОтпуска + " пропорционально отработанному времени";
					
				КонецЕсли;
				
			ИначеЕсли СтрокаОтпуска.ВидЕжегодногоОтпуска = Справочники.ВидыОтпусков.НайтиПоНаименованию("Отпуск за НРД",Ложь) Тогда
				
				ДнейНенормированногоОтпуска = СокрЛП(СтрокаОтпуска.КоличествоДнейВГод) + " календарных дней";
				
				Если СрочныйДоговор Тогда
					
					ДнейНенормированногоОтпуска = ДнейНенормированногоОтпуска + " пропорционально отработанному времени";
					
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЦикла;
		ПараметрыТрудовогоДоговора.ДнейВредногоОтпуска = ДнейВредногоОтпуска;
		ПараметрыТрудовогоДоговора.ДнейНенормированногоОтпуска = ДнейНенормированногоОтпуска;
		
		
		ПараметрыТрудовогоДоговора.Вставить("ДокументыРаботника", "");
		
		ПараметрыТрудовогоДоговора.ДокументыРаботника = Выборка.ДокументПредставление + 
		" зарегистрирован по адресу " + Выборка.АдресПоПропискеПредставление; 
		
		//заполнение пункта 10
		ПараметрыТрудовогоДоговора.Вставить("Пункт10","");
		Пункт10 = "";
		Если ДоговорСВодителем Тогда
			
			Пункт10 = "10. Работодатель, в связи с производственной необходимостью, имеет право переводить Работника сроком до одного месяца единовременно, на другой автомобиль с оплатой труда по выполняемой работе, но не ниже среднего заработка по основному месту работы.";
			
		Иначе
			Пункт10 = "10. В межотопительный период, в связи с ремонтными работами на котельной, работник переводится на восьми часовой рабочий день для проведения ремонтных работ с оплатой по фактически выполняемой работе, в соответствии с его квалификацией.";			
		КонецЕсли; 
		ПараметрыТрудовогоДоговора.Пункт10 = Пункт10;
		
		МассивПараметров = ДанныеДляПечати.Получить(ПараметрыТрудовогоДоговора.Ссылка);
		Если МассивПараметров = Неопределено Тогда
			
			МассивПараметров = Новый Массив;
			ДанныеДляПечати.Вставить(ПараметрыТрудовогоДоговора.Ссылка, МассивПараметров);
			
		КонецЕсли;
		
		МассивПараметров.Добавить(ПараметрыТрудовогоДоговора);
		
	КонецЦикла;
	
	Возврат ДанныеДляПечати;
	
КонецФункции 
