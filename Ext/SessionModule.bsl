﻿Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)
		
	Если НЕ ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("Администратор")) Тогда 
		
		Кл = Новый НастройкиКлиентскогоПриложения;
		Кл.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Такси;
		Кл.ВариантМасштабаФормКлиентскогоПриложения = ВариантМасштабаФормКлиентскогоПриложения.Обычный;
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиКлиентскогоПриложения",,Кл);
		
		КП = Новый НастройкиИнтерфейсаКлиентскогоПриложения;
		Состав = Новый НастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		КП.УстановитьСостав(Состав);
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиИнтерфейсаКлиентскогоПриложения", , КП);
		
	КонецЕсли;
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Пользователь = Справочники.Пользователи.НайтиПоНаименованию(ПользовательИБ);
	Если Пользователь.Пустая() Тогда 
		Пользователь = Справочники.Пользователи.СоздатьЭлемент();
		Пользователь.Наименование = ПользовательИБ;
		Пользователь.Записать();
	КонецЕсли;
	
	ПараметрыСеанса.ТекущийПользователь = Пользователь.Ссылка;
	
КонецПроцедуры
