
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура НайтиЗаказ(Команда)
СтруктураЗаказа=ПоискНаСервере();
Если СтруктураЗаказа<>Неопределено Тогда 
	Оповещение=новый ОписаниеОповещения("ПодтвердитьЗаказДляДокумента",ЭтаФорма,СтруктураЗаказа);
	ПоказатьВопрос(Оповещение,"Заказ найден, вы уверены, что хотите привязать его к текущей наборке?",РежимДиалогаВопрос.ДаНет);
КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура ПодтвердитьЗаказДляДокумента(Результат,Параметры) Экспорт
	Если Результат=КодВозвратаДиалога.Нет Тогда 
		Возврат
	КонецЕсли;
	ОповеститьОВыборе(Параметры);
КонецПроцедуры
		
&НаСервере
Функция  ПоискНаСервере()
СтруктураЗапросаДанных=новый Структура;
СтруктураЗапросаДанных.Вставить("ТипОбработкиДанных","ПоискЗаказа");
СтруктураЗапросаДанных.Вставить("КлючИнициализацииДанных",новый Структура("ДатаЗаказа,НомерЗаказа",ДатаЗаказа,НомерЗаказа));
СтруктураЗапросаДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураЗапросаДанных,"HandDial");
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураЗапросаДанных,"Заказ") Тогда 
	Возврат Неопределено;
КонецЕсли;
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураЗапросаДанных,"НомерЗаказа") Тогда 
	Возврат Неопределено;
КонецЕсли;
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураЗапросаДанных,"МассивДанныхНмЗаказа") Тогда 
	Возврат Неопределено;
КонецЕсли;
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураЗапросаДанных,"МассивДанныхЯчеечногоУчета") Тогда 
	Возврат Неопределено;
КонецЕсли;
Возврат СтруктураЗапросаДанных;
	КонецФункции