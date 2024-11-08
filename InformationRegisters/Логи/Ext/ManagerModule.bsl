﻿&НаСервере
Функция СнятьЗаписиОбновленияБазы(База) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Логи.Период,
	|	Логи.База,
	|	Логи.Лог,
	|	Логи.Результат,
	|	Логи.ДатаОкончания,
	|	Логи.Пользователь
	|ИЗ
	|	РегистрСведений.Логи КАК Логи
	|ГДЕ
	|	Логи.Результат = ЗНАЧЕНИЕ(Перечисление.РезультатыОбновлений.Обновляется)
	|	И Логи.База = &База");
	Запрос.УстановитьПараметр("База", База);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		Менеджер = РегистрыСведений.Логи.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Менеджер, Выборка);
		Менеджер.Лог = ПопыткаПолучитьЛог(База, Выборка.Период);
		Менеджер.Результат = Перечисления.РезультатыОбновлений.Ошибка;
		Менеджер.Записать(Истина);
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПоследнееНеДинамическоеОбновление(База) Экспорт 
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЛогиСрезПоследних.ДатаОкончания
	                      |ИЗ
	                      |	РегистрСведений.Логи.СрезПоследних(
	                      |			,
	                      |			База = &База
	                      |				И Лог ПОДОБНО ""%Старт не динамического обновления%"") КАК ЛогиСрезПоследних");
	Запрос.УстановитьПараметр("База", База);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.ДатаОкончания;	
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ПопыткаПолучитьЛог(База, Период)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ЛогиСрезПоследних.Лог,
	|	Базы.ПутьКФайлуЛогов
	|ИЗ
	|	РегистрСведений.Логи.СрезПоследних(&Период, База = &База) КАК ЛогиСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Базы КАК Базы
	|		ПО ЛогиСрезПоследних.База = Базы.Ссылка");
	Запрос.УстановитьПараметр("База", База);
	Запрос.УстановитьПараметр("Период", Период - 1);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		ЛогИзФайла = ОбновлениеВФоне.ПолучитьЛогИзФайла(Выборка.ПутьКФайлуЛогов);
		Если НЕ Найти(Выборка.Лог, ЛогИзФайла) Тогда 
			Возврат ЛогИзФайла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат "Что-то пошло не так...";
	
КонецФункции

&НаСервере
Процедура ОтложитьОбновление(МассивБаз) Экспорт 
	
	ТекстКода = "Константы.споОбновление.Установить(Ложь); 
	|  Результат = ЗначениеВСтрокуВнутр(Истина);";
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЛогиСрезПоследних.Период,
	                      |	ЛогиСрезПоследних.База,
						  |	ЛогиСрезПоследних.Лог,
	                      |	ЛогиСрезПоследних.Результат,
	                      |	ЛогиСрезПоследних.ДатаОкончания,
	                      |	ЛогиСрезПоследних.Пользователь
	                      |ИЗ
	                      |	РегистрСведений.Логи.СрезПоследних(
	                      |			,
	                      |			Результат = ЗНАЧЕНИЕ(Перечисление.РезультатыОбновлений.ОжидаетсяОтключениеПользователей)
	                      |				И База В (&Базы)) КАК ЛогиСрезПоследних");
	Запрос.УстановитьПараметр("Базы", МассивБаз);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Менеджер = РегистрыСведений.Логи.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Менеджер, Выборка);
		Менеджер.Результат = Перечисления.РезультатыОбновлений.ОбновлениеОтложено;
		Менеджер.Записать();
	КонецЦикла;
	
	Для Каждого База Из  МассивБаз Цикл 
		Результат = РаботаСВеб.ВыполнитьКодWS(База, ТекстКода);
	КонецЦикла;
	
КонецПроцедуры