﻿
&НаКлиенте
Процедура Тест(Команда)
	Если МассивОбъектов.Количество()>0 Тогда
		СоответствиеТаблДокументов = Новый Соответствие;
		ВызватьПолучениеТабДок(СоответствиеТаблДокументов);	
		
		//выводим окна с табличными документами
		Для каждого ЭлементСоответствия Из СоответствиеТаблДокументов Цикл
			ЭлементСоответствия.Значение.Показать(ЭлементСоответствия.Ключ);
		КонецЦикла; 
	иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не выбрано ни одного тестового объекта";
		Сообщение.Сообщить();
	КонецЕсли; 	
КонецПроцедуры


// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ВызватьПолучениеТабДок(СоответствиеТаблДокументов)

	ИдентификаторКоманды = "РеестрСертификатов"; //тот же - что и в функции "СведенияОВнешнейОбработке" модуля обработки!
	ОбъектОбр = РеквизитФормыВЗначение("Объект");
	КоллекцияПечатныхФорм = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм(ИдентификаторКоманды);
	ОбъектыПечати =  Новый СписокЗначений;
		
	Масс = Новый Массив;
	Для каждого ЭлмСписка Из МассивОбъектов Цикл
	     Масс.Добавить(ЭлмСписка.Значение);
	КонецЦикла; 
	
	ОбъектОбр.Печать(Масс, КоллекцияПечатныхФорм, ОбъектыПечати, Новый  Структура("ДоступнаПечатьПоКомплектно",Ложь));
	//подготовим визуализацию полученных печатных форм
	Для каждого ТекПечатнаяФорма Из КоллекцияПечатныхФорм Цикл
	       СоответствиеТаблДокументов.Вставить(ТекПечатнаяФорма.ИмяМакета,ТекПечатнаяФорма.ТабличныйДокумент);
	КонецЦикла; 

		
	
КонецПроцедуры // ВызватьПолучениеТабДок()
 