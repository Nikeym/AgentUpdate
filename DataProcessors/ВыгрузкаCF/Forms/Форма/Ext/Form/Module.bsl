﻿&НаКлиенте
Процедура ПриОткрытии(Отказ) 	
	ПриОткрытииНаСервере();	
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	Выгрузка = Новый Структура;
	ВыгрузитьИз = 2;
	ТекРелиз = РегистрыСведений.ДатыРелизов.ПолучитьТекущийРелиз();
	Если ТекРелиз = Неопределено Тогда 
		Сообщить("Тестовый контур не найден!");
		Возврат;
	КонецЕсли;
	ТестовыйКонтур = ТекРелиз.ТестовыйКонтур;
	Дата = ТекРелиз.ТестовыйКонтур;
	Каталог = Константы.КаталогДляВыгрузкиCf.Получить();
	Каталог = Каталог + ПеробразовательДатыВПапку(ТекРелиз.Период);
	
	Состояние = "На релиз " + Формат(РегистрыСведений.ДатыРелизов.ПолучитьДатуРелиза(ТестовыйКонтур), "ДФ=dd.MM.yyyy");
	
	Если НЕ ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("Администратор")) Тогда 
		Элементы.Каталог.ТолькоПросмотр = Истина;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПеробразовательДатыВПапку(Дата)
	Месяц = Строка(Месяц(Дата));
	День = Строка(День(Дата));
	Возврат Строка(Формат(Год(Дата), "ЧГ=0")) + ?(СтрДлина(Месяц) = 1, "0"+Месяц, Месяц) + ?(СтрДлина(День) = 1, "0"+День, День) + "_Пегас\";	
КонецФункции

&НаКлиенте
Процедура ТестовыйКонтурПриИзменении(Элемент)
	ТестовыйКонтурПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТестовыйКонтурПриИзмененииНаСервере()
	
	РелизДата = РегистрыСведений.ДатыРелизов.ПолучитьДатуРелиза(ТестовыйКонтур);
	Если РелизДата = Неопределено Тогда
		Каталог = "";
		Состояние = "Ближайший релиз на данный тестовый контур не найден!";
		Возврат;
	КонецЕсли;
	Каталог = Константы.КаталогДляВыгрузкиCf.Получить();
	Каталог = Каталог + ПеробразовательДатыВПапку(РелизДата);
	
	Состояние = "На релиз " + Формат(РелизДата, "ДФ=dd.MM.yyyy");
	
КонецПроцедуры

&НаКлиенте
Процедура Выгрузить(Команда)
	
	Выгрузка = Новый Структура;
	Элементы.Выгрузить.Доступность = Ложь;		
	Элементы.Индикатор.ОтображатьПроценты = Ложь;	
	Выгрузка = ВыгрузитьНаСервере();
	Если Выгрузка.ВыгрузкаЗапущена Тогда
		
		Выгрузка.Вставить("РазмерПоследнего", ПолучитьРазмерФайла(Выгрузка.ПутьКФайлуCF));

		ПодключитьОбработчикОжидания("ОбработкаОжиданияМедленно", 1, Ложь);

	Иначе 
		ПоказатьПредупреждение(, Выгрузка.Сообщение);
		Элементы.Выгрузить.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРазмерФайла(ПутьКФайлуCF)
	
	ФайлCF = Новый Файл(ПутьКФайлуCF);
	Первый = Истина;
	ПоследнийФайл = "";
	
	ФайлыВкаталоге = НайтиФайлы(ФайлCF.Путь,"*.cf");
	
	Для Каждого ФайлИзкаталога Из ФайлыВкаталоге Цикл 
		
		Если ФайлИзкаталога.ПолноеИмя = ПутьКФайлуCF Тогда 
			Продолжить;
		КонецЕсли;
		
		Если Первый Тогда 
			ПоследнийФайл = Новый Файл(ФайлИзкаталога.ПолноеИмя);
			Первый = Ложь;
			Продолжить;	
		КонецЕсли;
		
		Файл = Новый Файл(ФайлИзкаталога.ПолноеИмя); 
		
		Если Файл.ПолучитьВремяИзменения() > ПоследнийФайл.ПолучитьВремяИзменения() Тогда
			ПоследнийФайл = Файл;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ?(ПоследнийФайл = "", 130000000, ПоследнийФайл.Размер());
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСвойстваВыгружаемогоФайла(ПутьКФайлуCF)
	
	Структура = Новый Структура;
	ЦФ = Новый Файл(ПутьКФайлуCF);
	
	Если ЦФ.Существует() И ЦФ.Размер() > 100 Тогда
		Структура.Вставить("ВыгрузкаНачата", Истина);
		Структура.Вставить("Размер", ЦФ.Размер());
	Иначе 
		Структура.Вставить("ВыгрузкаНачата", Ложь);
	КонецЕсли;		
	
	Возврат Структура;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОжиданияМедленно()
	
	Если ФоновоеЗаданиеАктивно(Выгрузка.ЗаданиеID) Тогда
		
		СвойстваФайла = ПолучитьСвойстваВыгружаемогоФайла(Выгрузка.ПутьКФайлуCF);
		
		Если НЕ СвойстваФайла.ВыгрузкаНачата Тогда 
			
			Состояние = "Получение объектов из хранилища...";
			Индикатор = Индикатор + 10;
			Если Индикатор > 100 Тогда 
				Индикатор = 0;
			КонецЕсли;
			
		Иначе
			
			Состояние = "Выгрузка файла конфигурации...";
			Элементы.Индикатор.ОтображатьПроценты = Истина;
			Процент = (СвойстваФайла.Размер/Выгрузка.РазмерПоследнего) * 100;
			Индикатор = ?(Процент >=100, 99, Процент);
			
		КонецЕсли;
		
		//ЭтаФорма.ОбновитьОтображениеДанных();
		
	Иначе
		ОтключитьОбработчикОжидания("ОбработкаОжиданияМедленно");
		Результат = CFВыгружен(Выгрузка.ПутьКФайлуЛогов);
		Если Результат.Успех Тогда
			Индикатор = 100;
			ПоказатьПредупреждение(, "Файл успешно выгружен: " + Выгрузка.ПутьКФайлуCF);
			Состояние = "Файл выгружен: " + Выгрузка.ПутьКФайлуCF;
		Иначе
			ОткатитьИндикатор();
			ПоказатьПредупреждение(, "Ошибка! " + Результат.Лог);
			Состояние = "Ошибка при выгрузке CF...";
			УдалитьФайлНаСервере(Выгрузка.ПутьКФайлуCF);
		КонецЕсли;
		Элементы.Выгрузить.Доступность = Истина;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура УдалитьФайлНаСервере(ПутьКФайлу)
	Попытка
		УдалитьФайлы(ПутьКФайлу);
	Исключение	
	КонецПопытки;
КонецПроцедуры

&НаСервере
Функция ВыгрузитьНаСервере()
	
	ПапкаСРелизом = Новый Файл(Каталог);
	Если НЕ ПапкаСРелизом.Существует() Тогда
		СоздатьКаталог(Каталог);
	КонецЕсли;
	
	ВерсияКонф = ПолучитьВерсиюТК();
	Если ВерсияКонф = Неопределено Тогда
		Возврат Новый Структура("ВыгрузкаЗапущена, Сообщение", Ложь, "Не удалось получить версию конфигурации. Выгрузка невозможна!");	
	КонецЕсли;
	
	Н=1;
	Пока 1=1 Цикл
		Версия = ВерсияКонф + "+" +Строка(Н) + "+";
		Файлик = Новый Файл(Каталог + Версия + ".cf");
		Если НЕ Файлик.Существует() Тогда
			Возврат ЗапуститьВыгрузку(Каталог + Версия + ".cf");
		КонецЕсли;
		Н=Н+1;
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПолучитьВерсиюТК()
	
	Код = "Результат = ЗначениеВСтрокуВнутр(Метаданные.Версия + ""ПолученУспех"")";
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Базы.Ссылка
	|ИЗ
	|	Справочник.Базы КАК Базы
	|ГДЕ
	|	Базы.ТестовыйКонтур = &ТестовыйКонтур
	|	И НЕ Базы.Административная";
	Запрос.УстановитьПараметр("ТестовыйКонтур", ТестовыйКонтур);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		База = Выборка.Ссылка;
		Результат = РаботаСВеб.ВыполнитьКодWS(База, Код);
		Если НЕ Результат = "Ошибка" Тогда 
			Если Найти(Результат, "ПолученУспех") Тогда 
				Возврат СтрЗаменить(Результат, "ПолученУспех", "");
			Иначе 
				Продолжить;
			КонецЕсли;		
		КонецЕсли;	
	КонецЦикла;
	 	
	Возврат Неопределено;	
	
КонецФункции

&НаСервере
Функция ЗапуститьВыгрузку(ПутьКФайлуCF)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Базы.Ссылка,
	|	Базы.ПутьКФайлуЛогов
	|ИЗ
	|	Справочник.Базы КАК Базы
	|ГДЕ
	|	Базы.CF
	|	И Базы.ТестовыйКонтур = &ТестовыйКонтур";
	Запрос.УстановитьПараметр("ТестовыйКонтур", ТестовыйКонтур);	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		База = Выборка.Ссылка;
		ПрМассив = Новый Массив;
		ПрМассив.Добавить(ПутьКФайлуCF);
		ПрМассив.Добавить(База);
		ПрМассив.Добавить(?(ВыгрузитьИз = 1, Истина, Ложь));
		Попытка
			ФоновоеЗадание = ФоновыеЗадания.Выполнить("ОбновлениеВФоне.ВыполнитьСкриптВыгрузкаCF", ПрМассив, Строка(ТестовыйКонтур) + " CF");
			Возврат Новый Структура("ВыгрузкаЗапущена, Сообщение, ЗаданиеID, ПутьКФайлуCF, ПутьКФайлуЛогов", Истина, "Идет выгрузка.",  ФоновоеЗадание.УникальныйИдентификатор, ПутьКФайлуCF, Выборка.ПутьКФайлуЛогов); 		
		Исключение
			Ошибка = ОбработатьОшибку(ОписаниеОшибки());
			Возврат Новый Структура("ВыгрузкаЗапущена, Сообщение", Ложь, Ошибка)
		КонецПопытки;
	КонецЦикла;
	Возврат Новый Структура("ВыгрузкаЗапущена, Сообщение", Ложь, "Базы для выгрузки CF не обнаружены!");
	
КонецФункции

&НаСервере
Функция ОбработатьОшибку(Текст)

	Если Найти(Текст, "Задание с таким значением ключа уже выполняется") Тогда 
		Возврат "В данный момент выгрузка CF уже осуществляется!";
	КонецЕсли; 
		
	Возврат Текст;
		
КонецФункции

&НаСервере
Функция ПолучитьХранилище(ТестовыйКонтур)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Базы.Хранилище КАК Хранилище
		|ИЗ
		|	Справочник.Базы КАК Базы
		|ГДЕ
		|	Базы.ТестовыйКонтур = &ТестовыйКонтур";
	
	Запрос.УстановитьПараметр("ТестовыйКонтур", ТестовыйКонтур);
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		Возврат СокрЛП(Выборка.Хранилище);
	КонецЕсли;
	
	Возврат Неопределено;
		
КонецФункции

&НаКлиенте
Функция CFВыгружен (ПутьКФайлуЛогов)
	
	Ответ = Новый Структура;
	
	Лог = ОбновлениеВФоне.ПолучитьЛогИзФайла(ПутьКФайлуЛогов);
	Если Найти(Лог, "Выгрузка конфигурации из хранилища успешно завершена") ИЛИ Найти(Лог, "Сохранение конфигурации успешно завершено") Тогда 
		Ответ.Вставить("Успех", Истина);
		Ответ.Вставить("Лог", Лог);
	Иначе 
		Ответ.Вставить("Успех", Ложь);
		Ответ.Вставить("Лог", Лог);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

&НаКлиенте
Процедура КаталогПриИзменении(Элемент)
	
	Если НЕ Прав(Каталог, 1) = "\" Тогда 
		Каталог = Каталог + "\";
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФоновоеЗаданиеАктивно(ЗаданиеID)
	Возврат ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ЗаданиеID).Состояние = СостояниеФоновогоЗадания.Активно;
КонецФункции

&НаКлиенте
Процедура ОткатитьИндикатор()
	Пока Индикатор > 1 Цикл 
		Индикатор = Индикатор - 1;
		ЭтаФорма.ОбновитьОтображениеДанных();
	КонецЦикла;
	Индикатор = 0;
	ЭтаФорма.ОбновитьОтображениеДанных();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры
