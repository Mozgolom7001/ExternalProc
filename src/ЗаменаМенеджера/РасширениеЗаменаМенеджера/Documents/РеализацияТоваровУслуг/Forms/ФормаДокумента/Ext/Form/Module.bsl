﻿
&НаСервере
Процедура ЗМ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ЗаказКлиента) Тогда
			Возврат;
		Иначе
			Объект.Менеджер = Объект.ЗаказКлиента.Менеджер;
		КонецЕсли;          
				
	КонецЕсли; 
	
КонецПроцедуры
