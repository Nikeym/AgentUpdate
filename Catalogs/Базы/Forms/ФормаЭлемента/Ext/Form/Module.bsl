﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТолькоПросмотр Тогда
		Для Каждого Элем Из ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы Цикл 
			Элем.Видимость = Ложь;	
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестовыйКонтурПриИзменении(Элемент)
	
	Если Элемент.ВыделенныйТекст = "1-й тестовый контур" Тогда 
		Объект.Хранилище = "tcp://v-dcr-repo1c/Pegasus2013_TestC_1";
	ИначеЕсли Элемент.ВыделенныйТекст = "2-й тестовый контур" Тогда
		Объект.Хранилище = "tcp://v-dcr-repo1c/Pegasus2013_TestC_2";
	ИначеЕсли Элемент.ВыделенныйТекст = "" Тогда
		Объект.ТестовыйКонтур = "";
		Объект.Хранилище = "";
	КонецЕсли;
	
КонецПроцедуры
