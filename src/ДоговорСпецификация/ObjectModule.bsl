﻿Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.3.1.73");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	ПараметрыРегистрации.Версия = "1.0";
	// Определение объектов, к которым подключается эта обработка.
	ПараметрыРегистрации.Назначение.Добавить("Документ.ЗаказКлиента");
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'Договор / спецификация'");
	НоваяКоманда.Идентификатор = "ДоговорСпецификация";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	НоваяКоманда.Модификатор = "ПечатьMXL";
	
	Возврат ПараметрыРегистрации;
КонецФункции

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ДоговорСпецификация");
	Если ПечатнаяФорма <> Неопределено Тогда
		ПечатнаяФорма.ТабличныйДокумент = СформироватьДоговорСпецификацию(МассивОбъектов, ОбъектыПечати);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Договор / спецификацияу'");
	КонецЕсли;
КонецПроцедуры

Функция СформироватьДоговорСпецификацию(МассивОбъектов, ОбъектыПечати)
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_ДоговорСпецификация";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	ДанныеДляПечати = Документы.ЗаказКлиента.ПолучитьДанныеДляПечатнойФормыЗаказаНаТоварыУслуги(МассивОбъектов, Неопределено);
	
	ЗаполнитьТабличныйДокументДоговорСпецификация(
	ТабличныйДокумент,
	ДанныеДляПечати,
	ОбъектыПечати,
	"ПФ_MXL_ДоговорСпецификация");
	
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
Процедура ЗаполнитьТабличныйДокументДоговорСпецификация(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ИмяМакета)
	
	ШаблонОшибкиТовары	= НСтр("ru = 'В документе %1 отсутствуют товары. Печать %2 не требуется'");
	ШаблонОшибкиЭтапы	= НСтр("ru = 'В документе %1 отсутствуют этапы оплаты. Печать %2 не требуется'");
	
	ИспользоватьРучныеСкидки			= ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользоватьАвтоматическиеСкидки	= ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
	
	ДанныеПечати	= ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ЭтапыОплаты		= ДанныеДляПечати.РезультатПоЭтапамОплаты.Выгрузить();
	Товары			= ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();
	
	ПервыйДокумент	= Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Макет = ПолучитьМакет("ПФ_MXL_ДоговорСпецификация");
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		
		ТаблицаТовары = Товары.НайтиСтроки(СтруктураПоиска);
		
		Если ТаблицаТовары.Количество() = 0 Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонОшибкиТовары,
			ДанныеПечати.Ссылка,
			ДанныеПечати.ПредставлениеВОшибке);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДанныеПечати.Ссылка);
			Продолжить;
			
		КонецЕсли; 
		
		ТаблицаЭтапыОплаты = ЭтапыОплаты.НайтиСтроки(СтруктураПоиска);
		
		Если ПервыйДокумент Тогда
			ПервыйДокумент = Ложь;
		Иначе
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьСтрокаКомплект = Макет.ПолучитьОбласть("СтрокаКомплекта");
		ОбластьСтрокаКомплектующее = Макет.ПолучитьОбласть("СтрокаКомплектующее");
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		
		Договор = ДанныеПечати.Ссылка.Договор;
		
		НомерДоговора = Договор.Номер;
		ДатаДоговора = Формат(Договор.Дата, "ДФ=dd.MM.yyyy");
		
		Заголовок = "Спецификация к Договору № " + НомерДоговора + " от " + ДатаДоговора;
		
		ОбластьЗаголовок.Параметры.ЗаголовокСпецификации = Заголовок;
		
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		НомерПП = 1;
		СуммаИтого = 0;
		СуммаИтогоСоСкидкой = 0;
		Для каждого СтрокаТоваров Из ТаблицаТовары Цикл
			
			Если СтрокаТоваров.ЭтоНабор  Тогда
				
				ОбластьСтрокаКомплект.Параметры.НомерПоПорядку = НомерПП;
				НомерПП = НомерПП + 1;			
				
				ПредставлениеНоменклатурыДляПечати = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				СтрокаТоваров.НаименованиеПолное,
				СтрокаТоваров.Характеристика,
				,
				,
				);
				
				ОбластьСтрокаКомплект.Параметры.НаименованиеКомплекта = ПредставлениеНоменклатурыДляПечати;
				
				ОбластьСтрокаКомплект.Параметры.Заполнить(СтрокаТоваров);
				
				ТабличныйДокумент.Вывести(ОбластьСтрокаКомплект);
				СуммаИтого = СуммаИтого + СтрокаТоваров.СуммаБезСкидки;
				СуммаИтогоСоСкидкой = СуммаИтогоСоСкидкой + СтрокаТоваров.Сумма;
				
			ИначеЕсли СтрокаТоваров.ЭтоКомплектующие Тогда
				
				ПредставлениеНоменклатурыДляПечати = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				СтрокаТоваров.НаименованиеПолное,
				СтрокаТоваров.Характеристика,
				,
				,
				);
				
				ОбластьСтрокаКомплектующее.Параметры.НаименованиеКомплектующего = "    * " + ПредставлениеНоменклатурыДляПечати;
				
				ОбластьСтрокаКомплектующее.Параметры.Заполнить(СтрокаТоваров);
				
				ТабличныйДокумент.Вывести(ОбластьСтрокаКомплектующее);
				
			Иначе
				
				ОбластьСтрокаКомплект.Параметры.НомерПоПорядку = НомерПП;
				НомерПП = НомерПП + 1;			
				
				ПредставлениеНоменклатурыДляПечати = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				СтрокаТоваров.НаименованиеПолное,
				СтрокаТоваров.Характеристика,
				,
				,
				);
				
				ОбластьСтрокаКомплект.Параметры.НаименованиеКомплекта = ПредставлениеНоменклатурыДляПечати;
				
				ОбластьСтрокаКомплект.Параметры.Заполнить(СтрокаТоваров);
				
				ТабличныйДокумент.Вывести(ОбластьСтрокаКомплект);
				СуммаИтого = СуммаИтого + СтрокаТоваров.СуммаБезСкидки;
				СуммаИтогоСоСкидкой = СуммаИтогоСоСкидкой + СтрокаТоваров.Сумма;
				
				
			КонецЕсли; 
			
		КонецЦикла; 
		
		СтруктураПоиска = Новый Структура("ВариантОплаты", Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки);
		
		Предоплаты = ЭтапыОплаты.НайтиСтроки(СтруктураПоиска);
		СуммаПредоплаты = ПолучитьСуммуВнесеннойПредоплаты(ДанныеПечати);
		// 
		
		
		//Если НЕ Предоплаты.Количество() = 0 Тогда
		//
		//	Для каждого СтрокаПредоплат Из Предоплаты Цикл
		//	
		//		СуммаПредоплаты = СуммаПредоплаты + СтрокаПредоплат.СуммаПлатежа;
		//		
		//	КонецЦикла; 
		//
		//КонецЕсли; 
		
		
		
		ОбластьПодвал.Параметры.СуммаИтого = ФормированиеПечатныхФорм.ФорматСумм(СуммаИтого);
		ОбластьПодвал.Параметры.СуммаИтогоСоСкидкой = ФормированиеПечатныхФорм.ФорматСумм(СуммаИтогоСоСкидкой);
		
		
		ТекстИтоговойСтроки = НСтр("ru='Итого без учета сборки и доставки: %1, Предоплата %2, Остаток %3'");
		ИтоговаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстИтоговойСтроки,
		ФормированиеПечатныхФорм.ФорматСумм(СуммаИтогоСоСкидкой, ДанныеПечати.Валюта), // Суммаитого
		ФормированиеПечатныхФорм.ФорматСумм(СуммаПредоплаты, ДанныеПечати.Валюта), //Предоплата
		ФормированиеПечатныхФорм.ФорматСумм(СуммаИтогоСоСкидкой - СуммаПредоплаты, ДанныеПечати.Валюта)); // Остаток
		
		ОбластьПодвал.Параметры.ИтоговаяСтрока = ИтоговаяСтрока;
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
	КонецЦикла; 
	
КонецПроцедуры // ЗаполнитьТабличныйДокументДоговорСпецификация()

// <Описание функции>
//
// Параметры:
//  ДанныеПечати - 	 - 
// 
// Возвращаемое значение:
//  Сумма внесенной предоплаты - Число   - Сумма внесенной предоплаты или ноль
//
Функция ПолучитьСуммуВнесеннойПредоплаты(ДанныеПечати)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	Сегменты.Партнер КАК Партнер,
	               |	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	               |ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	               |ИЗ
	               |	РегистрСведений.ПартнерыСегмента КАК Сегменты
	               |{ГДЕ
	               |	Сегменты.Сегмент.* КАК СегментПартнеров,
	               |	Сегменты.Партнер.* КАК Партнер}
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Партнер,
	               |	ИспользуетсяОтборПоСегментуПартнеров
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	РегистрАналитикаУчетаПоПартнерам.Организация КАК Организация,
	               |	РегистрАналитикаУчетаПоПартнерам.Партнер КАК Партнер,
	               |	РегистрАналитикаУчетаПоПартнерам.Контрагент КАК Контрагент,
	               |	РегистрАналитикаУчетаПоПартнерам.Договор КАК Договор,
	               |	РегистрАналитикаУчетаПоПартнерам.НаправлениеДеятельности КАК НаправлениеДеятельности,
	               |	РегистрАналитикаУчетаПоПартнерам.КлючАналитики КАК КлючАналитики
	               |ПОМЕСТИТЬ АналикаУчетаПоПартнерам
	               |ИЗ
	               |	РегистрСведений.АналитикаУчетаПоПартнерам КАК РегистрАналитикаУчетаПоПартнерам
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	РасчетыСКлиентами.Период КАК Период,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.Регистратор = НЕОПРЕДЕЛЕНО
	               |			ТОГДА NULL
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА ТИПЗНАЧЕНИЯ(РасчетыСКлиентами.ЗаказКлиента) В (ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств), ТИП(Документ.СписаниеБезналичныхДенежныхСредств), ТИП(Документ.ПриходныйКассовыйОрдер), ТИП(Документ.РасходныйКассовыйОрдер), ТИП(Документ.ОперацияПоПлатежнойКарте), ТИП(Документ.ВводОстатков))
	               |						И РасчетыСКлиентами.Регистратор = &ТекущийДокумент
	               |					ТОГДА РасчетыСКлиентами.ЗаказКлиента
	               |				ИНАЧЕ РасчетыСКлиентами.Регистратор
	               |			КОНЕЦ
	               |	КОНЕЦ КАК Регистратор,
	               |	РасчетыСКлиентами.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	               |	ВЫБОР
	               |		КОГДА ТИПЗНАЧЕНИЯ(РасчетыСКлиентами.ЗаказКлиента) В (ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств), ТИП(Документ.СписаниеБезналичныхДенежныхСредств), ТИП(Документ.ПриходныйКассовыйОрдер), ТИП(Документ.РасходныйКассовыйОрдер), ТИП(Документ.ОперацияПоПлатежнойКарте), ТИП(Документ.ВводОстатков))
	               |				И РасчетыСКлиентами.Регистратор = &ТекущийДокумент
	               |			ТОГДА РасчетыСКлиентами.Регистратор
	               |		ИНАЧЕ РасчетыСКлиентами.ЗаказКлиента
	               |	КОНЕЦ КАК ЗаказКлиента,
	               |	РасчетыСКлиентами.Валюта КАК Валюта,
	               |	АналитикаПоПартнерам.Партнер КАК Партнер,
	               |	АналитикаПоПартнерам.Организация КАК Организация,
	               |	АналитикаПоПартнерам.Контрагент КАК Контрагент,
	               |	АналитикаПоПартнерам.Договор КАК Договор,
	               |	АналитикаПоПартнерам.НаправлениеДеятельности КАК НаправлениеДеятельности,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.СуммаНачальныйОстаток < 0
	               |			ТОГДА -РасчетыСКлиентами.СуммаНачальныйОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК НашДолгНачальныйОстаток,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.СуммаКонечныйОстаток < 0
	               |			ТОГДА -РасчетыСКлиентами.СуммаКонечныйОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК НашДолгКонечныйОстаток,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.СуммаНачальныйОстаток < 0
	               |				И РасчетыСКлиентами.КОтгрузкеНачальныйОстаток < 0
	               |				И (РасчетыСКлиентами.Период < &ДатаОтчета
	               |						И НАЧАЛОПЕРИОДА(РасчетыСКлиентами.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	               |					ИЛИ РасчетыСКлиентами.Период <> &ДатаОтчета)
	               |			ТОГДА ВЫБОР
	               |					КОГДА -РасчетыСКлиентами.СуммаНачальныйОстаток > -РасчетыСКлиентами.КОтгрузкеНачальныйОстаток
	               |						ТОГДА -РасчетыСКлиентами.КОтгрузкеНачальныйОстаток
	               |					ИНАЧЕ -РасчетыСКлиентами.СуммаНачальныйОстаток
	               |				КОНЕЦ
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК НашДолгПросроченоНачальныйОстаток,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.СуммаКонечныйОстаток < 0
	               |				И РасчетыСКлиентами.КОтгрузкеКонечныйОстаток < 0
	               |				И (РасчетыСКлиентами.Период < &ДатаОтчета
	               |						И НАЧАЛОПЕРИОДА(РасчетыСКлиентами.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	               |					ИЛИ РасчетыСКлиентами.Период <> &ДатаОтчета)
	               |			ТОГДА ВЫБОР
	               |					КОГДА -РасчетыСКлиентами.СуммаКонечныйОстаток > -РасчетыСКлиентами.КОтгрузкеКонечныйОстаток
	               |						ТОГДА -РасчетыСКлиентами.КОтгрузкеКонечныйОстаток
	               |					ИНАЧЕ -РасчетыСКлиентами.СуммаКонечныйОстаток
	               |				КОНЕЦ
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК НашДолгПросроченоКонечныйОстаток,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.СуммаНачальныйОстаток > 0
	               |			ТОГДА РасчетыСКлиентами.СуммаНачальныйОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ДолгКлиентаНачальныйОстаток,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.СуммаКонечныйОстаток > 0
	               |			ТОГДА РасчетыСКлиентами.СуммаКонечныйОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ДолгКлиентаКонечныйОстаток,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.СуммаНачальныйОстаток > 0
	               |				И РасчетыСКлиентами.КОплатеНачальныйОстаток > 0
	               |				И (РасчетыСКлиентами.Период < &ДатаОтчета
	               |						И НАЧАЛОПЕРИОДА(РасчетыСКлиентами.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	               |					ИЛИ РасчетыСКлиентами.Период <> &ДатаОтчета)
	               |			ТОГДА ВЫБОР
	               |					КОГДА РасчетыСКлиентами.СуммаНачальныйОстаток > РасчетыСКлиентами.КОплатеНачальныйОстаток
	               |						ТОГДА РасчетыСКлиентами.КОплатеНачальныйОстаток
	               |					ИНАЧЕ РасчетыСКлиентами.СуммаНачальныйОстаток
	               |				КОНЕЦ
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ДолгКлиентаПросроченоНачальныйОстаток,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.СуммаКонечныйОстаток > 0
	               |				И РасчетыСКлиентами.КОплатеКонечныйОстаток > 0
	               |				И (РасчетыСКлиентами.Период < &ДатаОтчета
	               |						И НАЧАЛОПЕРИОДА(РасчетыСКлиентами.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	               |					ИЛИ РасчетыСКлиентами.Период <> &ДатаОтчета)
	               |			ТОГДА ВЫБОР
	               |					КОГДА РасчетыСКлиентами.СуммаКонечныйОстаток > РасчетыСКлиентами.КОплатеКонечныйОстаток
	               |						ТОГДА РасчетыСКлиентами.КОплатеКонечныйОстаток
	               |					ИНАЧЕ РасчетыСКлиентами.СуммаКонечныйОстаток
	               |				КОНЕЦ
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ДолгКлиентаПросроченоКонечныйОстаток,
	               |	ВЫБОР
	               |		КОГДА РасчетыСКлиентами.СуммаОборот < 0
	               |			ТОГДА -РасчетыСКлиентами.СуммаОборот
	               |		ИНАЧЕ РасчетыСКлиентами.СуммаОборот
	               |	КОНЕЦ КАК Сумма,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(РасчетыСКлиентами.СуммаНачальныйОстаток, 0) > 0
	               |				И ЕСТЬNULL(РасчетыСКлиентами.ОтгружаетсяНачальныйОстаток, 0) <= 0
	               |			ТОГДА ЕСТЬNULL(РасчетыСКлиентами.СуммаНачальныйОстаток, 0)
	               |		КОГДА ЕСТЬNULL(РасчетыСКлиентами.СуммаНачальныйОстаток, 0) >= 0
	               |				И ЕСТЬNULL(РасчетыСКлиентами.ОтгружаетсяНачальныйОстаток, 0) > 0
	               |			ТОГДА ЕСТЬNULL(РасчетыСКлиентами.СуммаНачальныйОстаток, 0) + ЕСТЬNULL(РасчетыСКлиентами.ОтгружаетсяНачальныйОстаток, 0)
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ДолгКлиентаВсегоНачальныйОстаток,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(РасчетыСКлиентами.СуммаКонечныйОстаток, 0) > 0
	               |				И ЕСТЬNULL(РасчетыСКлиентами.ОтгружаетсяКонечныйОстаток, 0) <= 0
	               |			ТОГДА ЕСТЬNULL(РасчетыСКлиентами.СуммаКонечныйОстаток, 0)
	               |		КОГДА ЕСТЬNULL(РасчетыСКлиентами.СуммаКонечныйОстаток, 0) >= 0
	               |				И ЕСТЬNULL(РасчетыСКлиентами.ОтгружаетсяКонечныйОстаток, 0) > 0
	               |			ТОГДА ЕСТЬNULL(РасчетыСКлиентами.СуммаКонечныйОстаток, 0) + ЕСТЬNULL(РасчетыСКлиентами.ОтгружаетсяКонечныйОстаток, 0)
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ДолгКлиентаВсегоКонечныйОстаток
	               |ИЗ
	               |	РегистрНакопления.РасчетыСКлиентами.ОстаткиИОбороты(
	               |			,
	               |			,
	               |			Регистратор,
	               |			,
	               |			АналитикаУчетаПоПартнерам В
	               |					(ВЫБРАТЬ
	               |						АналикаУчетаПоПартнерам.КлючАналитики
	               |					ИЗ
	               |						АналикаУчетаПоПартнерам КАК АналикаУчетаПоПартнерам)
	               |				И ЗаказКлиента = &ТекущийДокумент {(ЗаказКлиента В (&ЗаказКлиентаОтбор)) КАК Поле2}) КАК РасчетыСКлиентами
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ АналикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	               |		ПО РасчетыСКлиентами.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики
	               |ГДЕ
	               |	(РасчетыСКлиентами.СуммаОборот <> 0
	               |			ИЛИ РасчетыСКлиентами.ОтгружаетсяОборот <> 0)
	               |	И АналитикаПоПартнерам.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	               |	И (&ТекущийДокумент = НЕОПРЕДЕЛЕНО
	               |			ИЛИ НЕ ТИПЗНАЧЕНИЯ(РасчетыСКлиентами.ЗаказКлиента) В (ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств), ТИП(Документ.СписаниеБезналичныхДенежныхСредств), ТИП(Документ.ПриходныйКассовыйОрдер), ТИП(Документ.РасходныйКассовыйОрдер), ТИП(Документ.ОперацияПоПлатежнойКарте), ТИП(Документ.ВводОстатков))
	               |			ИЛИ ТИПЗНАЧЕНИЯ(РасчетыСКлиентами.ЗаказКлиента) В (ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств), ТИП(Документ.СписаниеБезналичныхДенежныхСредств), ТИП(Документ.ПриходныйКассовыйОрдер), ТИП(Документ.РасходныйКассовыйОрдер), ТИП(Документ.ОперацияПоПлатежнойКарте), ТИП(Документ.ВводОстатков))
	               |				И РасчетыСКлиентами.Регистратор = &ТекущийДокумент)
	               |{ГДЕ
	               |	(АналитикаПоПартнерам.Партнер В
	               |			(ВЫБРАТЬ
	               |				ОтборПоСегментуПартнеров.Партнер
	               |			ИЗ
	               |				ОтборПоСегментуПартнеров
	               |			ГДЕ
	               |				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров)) КАК Поле2}
	               |ИТОГИ
	               |	СУММА(Сумма)
	               |ПО
	               |	ЗаказКлиента";
	
	Запрос.УстановитьПараметр("ДатаОтчета", Дата(1,1,1));
	
	ОтборныйМассив = Новый Массив;
	ОтборныйМассив.Добавить(ДанныеПечати.Ссылка);
	Запрос.УстановитьПараметр("ЗаказКлиентаОтбор", ОтборныйМассив);
	Запрос.УстановитьПараметр("ТекущийДокумент", ДанныеПечати.Ссылка);
	//Запрос.УстановитьПараметр("ИспользуетсяОтборПоСегментуПартнеров", Ложь);
	
	Результат = Запрос.Выполнить();
	
	Если не Результат.Пустой() Тогда
		
		ВыборкаЗаказ = Результат.Выбрать();
		ВыборкаЗаказ.Следующий();
		Возврат ВыборкаЗаказ.Сумма;
		
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции // ПолучитьСуммуВнесеннойПредоплаты()
