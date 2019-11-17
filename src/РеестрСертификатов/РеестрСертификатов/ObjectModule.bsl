﻿//ПОДГОТОВКА РЕГИСТРАЦИИ ОБРАБОТКИ

// Интерфейс для регистрации обработки.
// Вызывается при добавлении обработки в справочник "ВнешниеОбработки"
//
// Возвращаемое значение:
// Структура:
// Вид - строка - возможные значения:	"ДополнительнаяОбработка"
//										"ДополнительныйОтчет"
//										"ЗаполнениеОбъекта"
//										"Отчет"
//										"ПечатнаяФорма"
//										"СозданиеСвязанныхОбъектов"
//
// Назначение - массив строк имен объектов метаданных в формате:
//			<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]
//			Например, "Документ.СчетЗаказ" или "Справочник.*"
//			Прим. параметр имеет смысл только для назначаемых обработок
//
// Наименование - строка - наименование обработки, которым будет заполнено
//						наименование справочника по умолчанию - краткая строка для
//						идентификации обработки администратором
//
// Версия - строка - версия обработки в формате <старший номер>.<младший номер>
//					используется при загрузке обработок в информационную базу
// БезопасныйРежим – Булево – Если истина, обработка будет запущена в безопасном режиме.
//							Более подбробная информация в справке.
//
// Информация - Строка- краткая информация по обработке, описание обработки
//
// ВерсияБСП - Строка - Минимальная версия БСП, на которую рассчитывает код
// дополнительной обработки. Номер версии БСП задается в формате «РР.ПП.ВВ.СС»
// (РР – старший номер редакции; ПП – младший номер ре-дакции; ВВ – номер версии; СС – номер сборки).
//
// Команды - ТаблицаЗначений - команды, поставляемые обработкой, одная строка таблицы соотвествует
//							одной команде
//				колонки: 
//				 - Представление - строка - представление команды конечному пользователю
//				 - Идентификатор - строка - идентефикатор команды. В случае печатных форм
//											перечисление через запятую списка макетов
//				 - Использование - строка - варианты запуска обработки:
//						"ОткрытиеФормы" - открыть форму обработки
//						"ВызовКлиентскогоМетода" - вызов клиентского экспортного метода из формы обработки
//						"ВызовСерверногоМетода" - вызов серверного экспортного метода из модуля объекта обработки
//				 - ПоказыватьОповещение – Булево – если Истина, требуется оказывать оповещение при начале
//								и при окончании запуска обработки. Прим. Имеет смысл только
//								при запуске обработки без открытия формы.
//				 - Модификатор – строка - для печатных форм MXL, которые требуется
//										отображать в форме ПечатьДокументов подсистемы Печать
//										требуется установить как "ПечатьMXL"
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма"); //Варианты: "ДополнительнаяОбработка", "ДополнительныйОтчет", "ЗаполнениеОбъекта", "Отчет", "ПечатнаяФорма", "СозданиеСвязанныхОбъектов" 
	
	МассивНазначений = Новый Массив();
	МассивНазначений.Добавить("Документ.РеализацияТоваровУслуг");// например: "Документ._ДемоСчетНаОплатуПокупателю"
	МассивНазначений.Добавить("Документ.ПриобретениеТоваровУслуг");
	МассивНазначений.Добавить("Документ.ЗаказКлиента");
	МассивНазначений.Добавить("Документ.ЗаказПоставщику");
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	
	ПараметрыРегистрации.Вставить("Наименование", "Реестр сертификатов");
	ПараметрыРегистрации.Вставить("Версия", "1.4"); //например: "1.0"
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина); //Варианты: Истина, Ложь
	ПараметрыРегистрации.Вставить("Информация", "");
	ПараметрыРегистрации.Вставить("ВерсияБСП", "3.0.3.64");// не ниже какой версии БСП подерживается обработка
	
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	
	ДобавитьКоманду(ТаблицаКоманд,
	НСтр("ru = 'ВНЕШНИЙ: Реестр сертификатов'"),//для отображения пользователю
	"РеестрСертификатов",    //можно использовать для подмены поставляемой печатной формы
	"ВызовСерверногоМетода",  //Использование.  Варианты: "ОткрытиеФормы", "ВызовКлиентскогоМетода", "ВызовСерверногоМетода"   
	Ложь,//Показывать оповещение. Варианты Истина, Ложь 
	"ПечатьMXL",//Модификатор 
	""); //Строка с идентификаторами заменяемых внутренних печатных форм. Например "Счет,Заказ"
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ЗаменяемыеКоманды", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "",ЗаменяемыеКоманды = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	НоваяКоманда.ЗаменяемыеКоманды = ЗаменяемыеКоманды;
	
КонецПроцедуры



//ФОРМИРОВАНИЕ ПЕЧАТНОЙ ФОРМЫ

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода = Неопределено)  экспорт 
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеестрСертификатов") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"РеестрСертификатов", //тот же - что и в функции "СведенияОВнешнейОбработке"! 
		"Имя закладки 1 при печати комплектом", 
		СформироватьПечатнуюФорму1(МассивОбъектов, ОбъектыПечати)//исполняющая функция (в этом же модуле)
		);
	КонецЕсли;
	
КонецПроцедуры				

Функция СформироватьПечатнуюФорму1(МассивОбъектов, ОбъектыПечати)	
	
	//формирование табличного документа ТабДок
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.КлючПараметровПечати = "ПараметрыПечати_<УникальныйКлюч1>";	
	
	Макет = ПолучитьМакет("ПФ_MXL_РеестрСертификатов");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПриобретениеТоваровУслугТовары.Номенклатура КАК Номенклатура,
	|	ПриобретениеТоваровУслугТовары.Номенклатура.ВестиУчетСертификатовНоменклатуры КАК ВестиУчетСертификатовНоменклатуры,
	|	ПриобретениеТоваровУслугТовары.Ссылка КАК Ссылка,
	|	ПриобретениеТоваровУслугТовары.Ссылка.Контрагент КАК Контрагент,
	|	ПриобретениеТоваровУслугТовары.Ссылка.Организация КАК Организация,
	|	ПриобретениеТоваровУслугТовары.Ссылка.Номер КАК Номер,
	|	ПриобретениеТоваровУслугТовары.Ссылка.Дата КАК Дата,
	|	ТИПЗНАЧЕНИЯ(ПриобретениеТоваровУслугТовары.Ссылка) КАК ТипДокумента
	|ПОМЕСТИТЬ ВТ_Товары
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Товары КАК ПриобретениеТоваровУслугТовары
	|ГДЕ
	|	ПриобретениеТоваровУслугТовары.Ссылка В(&МассивОбъектов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РеализацияТоваровУслугТовары.Номенклатура,
	|	РеализацияТоваровУслугТовары.Номенклатура.ВестиУчетСертификатовНоменклатуры,
	|	РеализацияТоваровУслугТовары.Ссылка,
	|	РеализацияТоваровУслугТовары.Ссылка.Контрагент,
	|	РеализацияТоваровУслугТовары.Ссылка.Организация,
	|	РеализацияТоваровУслугТовары.Ссылка.Номер,
	|	РеализацияТоваровУслугТовары.Ссылка.Дата,
	|	ТИПЗНАЧЕНИЯ(РеализацияТоваровУслугТовары.Ссылка)
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|ГДЕ
	|	РеализацияТоваровУслугТовары.Ссылка В(&МассивОбъектов)
	|	И РеализацияТоваровУслугТовары.Номенклатура.ВестиУчетСертификатовНоменклатуры = ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура,
	|	ЗаказКлиентаТовары.Номенклатура.ВестиУчетСертификатовНоменклатуры,
	|	ЗаказКлиентаТовары.Ссылка,
	|	ЗаказКлиентаТовары.Ссылка.Контрагент,
	|	ЗаказКлиентаТовары.Ссылка.Организация,
	|	ЗаказКлиентаТовары.Ссылка.Номер,
	|	ЗаказКлиентаТовары.Ссылка.Дата,
	|	ТИПЗНАЧЕНИЯ(ЗаказКлиентаТовары.Ссылка)
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|ГДЕ
	|	ЗаказКлиентаТовары.Ссылка В(&МассивОбъектов)
	|	И ЗаказКлиентаТовары.Номенклатура.ВестиУчетСертификатовНоменклатуры = ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаказПоставщикуТовары.Номенклатура,
	|	ЗаказПоставщикуТовары.Номенклатура.ВестиУчетСертификатовНоменклатуры,
	|	ЗаказПоставщикуТовары.Ссылка,
	|	ЗаказПоставщикуТовары.Ссылка.Контрагент,
	|	ЗаказПоставщикуТовары.Ссылка.Организация,
	|	ЗаказПоставщикуТовары.Ссылка.Номер,
	|	ЗаказПоставщикуТовары.Ссылка.Дата,
	|	ТИПЗНАЧЕНИЯ(ЗаказПоставщикуТовары.Ссылка)
	|ИЗ
	|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
	|ГДЕ
	|	ЗаказПоставщикуТовары.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Товары.Ссылка КАК Ссылка,
	|	ВТ_Товары.Контрагент КАК Контрагент,
	|	ВТ_Товары.Организация КАК Организация,
	|	ВТ_Товары.Номер КАК НомерДок,
	|	ВТ_Товары.Дата КАК ДатаДок,
	|	ВТ_Товары.ТипДокумента КАК ТипДокумента
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Товары.Ссылка,
	|	ВТ_Товары.Контрагент,
	|	ВТ_Товары.Организация,
	|	ВТ_Товары.Номер,
	|	ВТ_Товары.Дата,
	|	ВТ_Товары.ТипДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ОбластиДействияСертификатовНоменклатуры.СертификатНоменклатуры, ЛОЖЬ) КАК СертификатНоменклатуры,
	|	ЕстьNull(ОбластиДействияСертификатовНоменклатуры.СертификатНоменклатуры.ДатаНачалаСрокаДействия, ДатаВремя(1,1,1)) КАК ДатаНачалаСрокаДействия,
	|	ЕстьNull(ОбластиДействияСертификатовНоменклатуры.СертификатНоменклатуры.ДатаОкончанияСрокаДействия, ДатаВремя(1,1,1)) КАК ДатаОкончанияСрокаДействия,
	|	ЕстьNull(ОбластиДействияСертификатовНоменклатуры.СертификатНоменклатуры.Бессрочный, Ложь) КАК Бессрочный,
	|	ЕстьNull(ОбластиДействияСертификатовНоменклатуры.СертификатНоменклатуры.ОрганВыдавшийДокумент, "") КАК ОрганВыдавшийДокумент,
	|	ЕстьNull(ОбластиДействияСертификатовНоменклатуры.СертификатНоменклатуры.Номер, "") КАК НомерСертификата,
	|	ОбластиДействияСертификатовНоменклатуры.СертификатНоменклатуры.Статус КАК Статус,
	|	ВТ_Товары.Ссылка КАК Ссылка,
	|	ВТ_Товары.Номенклатура КАК Номенклатура,
	|	ЕСТЬNULL(ВТ_Товары.ВестиУчетСертификатовНоменклатуры, Ложь) КАК ВестиУчетСертификатовНоменклатуры
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбластиДействияСертификатовНоменклатуры КАК ОбластиДействияСертификатовНоменклатуры
	|		ПО ВТ_Товары.Номенклатура = ОбластиДействияСертификатовНоменклатуры.Номенклатура";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаДокументы = РезультатЗапроса[1].Выбрать(); //Документы
	ВыборкаДетальныеЗаписи = РезультатЗапроса[2].Выбрать(); // Сертификаты
	
	ВставлятьРазделительСтраниц = Ложь;
	Пока ВыборкаДокументы.Следующий() Цикл
		СтруктураПараметров = Новый Структура;
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;	
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		
		ТипДокумента = "";
		Если ТипЗнч(ВыборкаДокументы.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			
			ТипДокумента = "Реализации товаров";
			
		ИначеЕсли ТипЗнч(ВыборкаДокументы.Ссылка) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
			
			ТипДокумента = "Приобретению товаров";
			
		ИначеЕсли ТипЗнч(ВыборкаДокументы.Ссылка) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			
			ТипДокумента = "Заказу клиента";
			
		ИначеЕсли ТипЗнч(ВыборкаДокументы.Ссылка) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			
			ТипДокумента = "Заказу поставщику";
			
		КонецЕсли; 
		
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("по %1 №%2 от %3", 
		ТипДокумента,
		ВыборкаДокументы.НомерДок,
		Формат(ВыборкаДокументы.ДатаДок, "ДФ='''""''dd''""'' MMMM yyyy ''г.'''"));
		
		СтруктураПараметров.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		
		СтруктураПараметров.Вставить("ПоставщикНаименование",
		ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаДокументы.Организация, ВыборкаДокументы.ДатаДок),
		"ПолноеНаименование"));
		СтруктураПараметров.Вставить("ПоставщикАдрес",
		ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаДокументы.Организация, ВыборкаДокументы.ДатаДок),
		"ЮридическийАдрес"));
		СтруктураПараметров.Вставить("ПоставщикТелефон",
		ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаДокументы.Организация, ВыборкаДокументы.ДатаДок),
		"Телефоны"));
		
		СтруктураПараметров.Вставить("ПокупательНаименование",
		ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаДокументы.Контрагент, ВыборкаДокументы.ДатаДок),
		"ПолноеНаименование"));
		СтруктураПараметров.Вставить("ПокупательАдрес",
		ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаДокументы.Контрагент, ВыборкаДокументы.ДатаДок),
		"ЮридическийАдрес"));
		СтруктураПараметров.Вставить("ПокупательТелефон",
		ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаДокументы.Контрагент, ВыборкаДокументы.ДатаДок),
		"Телефоны"));
		ОбластьШапка.Параметры.Заполнить(СтруктураПараметров);
		
		ТабДок.Вывести(ОбластьШапка);
		
		
		Область = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабДок.Вывести(Область);
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаДокументы.Ссылка);
		ТипИсточника = ТипЗнч(ВыборкаДокументы.Ссылка);
		
		ВыборкаДетальныеЗаписи.Сбросить();
		НомерСтроки = 0;
		Пока ВыборкаДетальныеЗаписи.НайтиСледующий(СтруктураПоиска) Цикл //перебора массива объектов
			Если ТипИсточника = Тип("ДокументСсылка.РеализацияТоваровУслуг") И
				ВыборкаДетальныеЗаписи.ВестиУчетСертификатовНоменклатуры И
				НЕ ВыборкаДетальныеЗаписи.Бессрочный И
				ВыборкаДетальныеЗаписи.ДатаОкончанияСрокаДействия >= ВыборкаДокументы.Ссылка.Дата И
				ВыборкаДетальныеЗаписи.ДатаНачалаСрокаДействия <= ВыборкаДокументы.Ссылка.Дата Тогда
				
				Продолжить;
				
			КонецЕсли; 
			
			НомерСтроки = НомерСтроки + 1;
			//Область = Макет.ПолучитьОбласть("СтрокаТаблицы");
			СтруктураПараметров.Вставить("НомерСтроки", НомерСтроки);
			
			СтруктураПараметров.Вставить("Товар", ВыборкаДетальныеЗаписи.Номенклатура);
			
			ТекстСертификата = "";
			
			Если ВыборкаДетальныеЗаписи.ВестиУчетСертификатовНоменклатуры Тогда
				Область = Макет.ПолучитьОбласть("СтрокаТаблицыЕстьСертификат");
				СтруктураПараметров.Вставить("НомерСертификата", ВыборкаДетальныеЗаписи.НомерСертификата);
				СтруктураПараметров.Вставить("ОрганВыдавшийДокумент", ВыборкаДетальныеЗаписи.ОрганВыдавшийДокумент);

				Если ВыборкаДетальныеЗаписи.Бессрочный Тогда
					
					СтруктураПараметров.Вставить("ДатаОкончанияСрокаДействия", "Бессрочный");
					
					//ТекстСертификата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					//"№%1 без срока окончания выдан %2",
					//ВыборкаДетальныеЗаписи.НомерСертификата,
					//СокрЛП(ВыборкаДетальныеЗаписи.ОрганВыдавшийДокумент));
					
				Иначе
					
					СтруктураПараметров.Вставить("ДатаОкончанияСрокаДействия", Формат(ВыборкаДетальныеЗаписи.ДатаОкончанияСрокаДействия, "ДЛФ=DD"));
					
					//ТекстСертификата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					//"№%1 действует до %2 выдан %3",
					//ВыборкаДетальныеЗаписи.НомерСертификата,
					//Формат(ВыборкаДетальныеЗаписи.ДатаОкончанияСрокаДействия,"ДЛФ=DD"),
					//СокрЛП(ВыборкаДетальныеЗаписи.ОрганВыдавшийДокумент));
					
				КонецЕсли; 
				
			Иначе
				
				Область = Макет.ПолучитьОбласть("СтрокаТаблицыНетСертификата");
				ТекстСертификата = "< По номенклатуре не ведется учет сертификатов >";
				
			КонецЕсли;
			
			СтруктураПараметров.Вставить("Сертификат", ТекстСертификата);
			
			Область.Параметры.Заполнить(СтруктураПараметров);
			
			ТабДок.Вывести(Область);
			
		КонецЦикла; //перебора массива объектов 
		
		Область = Макет.ПолучитьОбласть("ПодвалТаблицы");
		СтруктураПараметров.Вставить("ПоставщикНаименование",
		ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаДокументы.Организация, ВыборкаДокументы.ДатаДок),
		"ПолноеНаименование"));
		Область.Параметры.Заполнить(СтруктураПараметров);
		
		ТабДок.Вывести(Область);
		
		ВставлятьРазделительСтраниц = Истина;
		//подключимся к общ механизму обл печати
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДетальныеЗаписи.Ссылка);
		
	КонецЦикла;	
	Возврат ТабДок;
	
КонецФункции

