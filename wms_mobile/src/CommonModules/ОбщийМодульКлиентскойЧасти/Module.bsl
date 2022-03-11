// Процедура - Переопределения тригера получение штрих кода при закрытии
// возвращает ТригерПриемаСканераШтрихКода владельцу закрывающейся формы.
// Параметры:
//  Форма	 - УправляемаяФорма	 - форма в которой совершается событие закрития
//
Процедура ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(Форма)Экспорт
	Если Форма.ВладелецФормы <> Неопределено тогда
	Форма.ВладелецФормы.ТригерПриемаСканераШтрихКода=Истина;
	КонецЕсли;
КонецПроцедуры
// Процедура - Переопределения тригера получение штрих кода при открытии
// Устанавливает ТригерПриемаСканераШтрихКода открывающейся формы
// Параметры:
//  Форма	 - УправляемаяФорма	 - Форма из в которой осуществляется событие "ПриОткрытии"
//
Процедура ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(Форма)Экспорт
	Форма.ТригерПриемаСканераШтрихКода=Истина;
КонецПроцедуры

// Процедура - Сообщить через форму
// процедура открывает отдельное окно формы ОбщаяФорма.СообщениеПользователю в котором выводится сообщение
// Параметры:
//  Сообщение	 - Строка - сообщение пользователю 
//
Процедура СообщитьЧерезФорму(Сообщение) Экспорт 
	ОткрытьФорму("ОбщаяФорма.СообщениеПользователю",Новый Структура("Сообщение",Сообщение));
КонецПроцедуры


// Процедура - Оповещение динамических списков открытых форм
// Оповещает все формы событием ОбновлениеДанныхДинамическихСписков
// в большинстве форм на это событие описан обработчик обновления динамических списков
Процедура ОповещениеДинамическихСписковОткрытыхФорм() Экспорт 
	Оповестить("ОбновлениеДанныхДинамическихСписков",Истина,ЭтотОбъект);
КонецПроцедуры

// Процедура - Проверить SSCCНа леквидность
// ПроверитьSSCCНаЛеквидность уже имеется в модуле СлужебныеФункцииИПроцедурыКлиентСервер - в данном случае продублирована для доступа клиента.
// Проверяет на соответствие формату RAR считанный SSCC 
// Параметры:
//  СчитанныйSSCC	 - Строка - идентификатор паллеты
//  Отказ			 - Булево - флаг ошибки при проверки
//
Процедура ПроверитьSSCCНаЛеквидность(СчитанныйSSCC,Отказ) Экспорт 
СлужебныеФункцииИПроцедурыКлиентСервер.ПроверитьSSCCНаЛеквидность(СчитанныйSSCC,Отказ);
	КонецПроцедуры
	
	
// Функция - Получить18 символьный SSCCИз20
// Преобразует SSCC( идентификатор упаковки )(паллеты) из 20 символьного в 18 символьный 
// если 20 символьный идентификатор начинается с "00", в итоге на выходе получаем идентификатор без ътих нулей.
// Параметры:
//  SSCCВходящий - Строка	 -  идентификатор упаковки
// 
// Возвращаемое значение:
// Строка  - Преобразованный идентификатор упаковки 
//
Функция  Получить18СимвольныйSSCCИз20(SSCCВходящий) Экспорт 
	Возврат СлужебныеФункцииИПроцедурыКлиентСервер.Получить18СимвольныйSSCCИз20(SSCCВходящий);	
КонецФункции
		