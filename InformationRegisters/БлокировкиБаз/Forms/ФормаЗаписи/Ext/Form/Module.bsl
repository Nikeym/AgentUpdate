﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТолькоПросмотр Тогда
		Для Каждого Элем Из ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы Цикл 
			Элем.Видимость = Ложь;	
		КонецЦикла;
		Элементы.ЗавершениеРаботы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры
