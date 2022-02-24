
////блок используется в случае внешнего события	
#Область ПерехватСканирования
// Процедура - Подключить обработчик штрих кода
// Подключает  Обработчик  Уведомлений, который получает данные с драйвера оборудования Считывания шк и передает результат 
// в процедуру указанную в оповещении
Процедура ПодключитьОбработчикШтрихКода() Экспорт
	#Если МобильноеПриложениеКлиент  тогда
	ОповещениеШтрихКода = новый ОписаниеОповещения("ОбработчикЛокальныхУведомлений",ЭтотОбъект);
	ДоставляемыеУведомления.ПодключитьОбработчикУведомлений(ОповещениеШтрихКода);
	#КонецЕсли

КонецПроцедуры
// Процедура - Обработчик локальных уведомлений
// Получает данные с драйвера считывания шк , временно обрезает паллеты 20 символов до 18 символов
// и оповещает все открытые формы  о полученном шк
//
// Параметры:
//  Уведомление	 - Произвольный	 - Объект, содержащий данные уведомления, у которого заполнены 
//  только поля "Текст" и "Данные", остальные содержат значения по умолчанию. 
//  Локальное	 - Булево -  Истина - уведомление было создано локально операционной системой. Ложь - было получено Push-уведомление.
//  Показано	 - Булево -  Указывает, что уведомление было показано пользователю средствами операционной системы.
//  ДопПараметры - Произвольный - дполнительные параметры
//
Процедура ОбработчикЛокальныхУведомлений(Уведомление,Локальное,Показано,ДопПараметры)Экспорт
	Если Уведомление.Текст="DataSerialModelVersion" тогда
	     СлужебныеФункцииИПроцедурыКлиентСервер.ЗаписьСервесныхДанныхВКонстанты(Уведомление.Данные);
    КонецЕсли;
	Если Уведомление.Текст="ScanHoneywell" тогда 
		Попытка
			/////-КостыльПоЗаводскимSSCC Присекам на корню
			ШК=Уведомление.Данные;
			ПривестиSSCCК18СимволамКлиент(ШК);
			/////////----------------------------------------
			Оповестить("ОбработчикШтрихКода",ШК,"ОбработчикШтрихКода");
			//Сообщить(Строка(Уведомление.Данные));
		исключение
			Оповестить("ОбработчикШтрихКода",404,"ОшибкаЧтения");
		КонецПопытки;
		//Оповестить("ОбработчикШтрихКода",404,"ист");
	КонецЕсли;
	Если Уведомление.Текст="ЗавршениеРаботыWMS" тогда
		Если Не СлужебныеФункцииИПроцедурыКлиентСервер.ПараметрыСеансаОтветСервера("униРежимПодключенияЧерезUWS") Тогда     //SDE
			СлужебныеФункцииИПроцедурыКлиентСервер.ПередЗавершениемРаботыСистемы();
		КонецЕсли; 	 //SDE	
	КонецЕсли;
КонецПроцедуры
// Процедура - Привести SSCCК18 символам клиент
// если идентификатор упаковки длиной 20 символов и первые 2 символа = "00" тогда удаляет их из SSCC 
//
// Параметры:
//  SSCC - Строка - идентификатор упаковки(паллеты)
//
Процедура ПривестиSSCCК18СимволамКлиент(SSCC) Экспорт 
	Если СтрДлина(SSCC)=20  тогда
		Если Лев(SSCC,2)="00" Тогда 
			//Приведение к 20 к 18 символам (костыль из за заводов)
			SSCC=Прав(SSCC,18);
			//
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура  ОбработчикВнешнихСобытийМобильнойКомпоненты(Источник, Событие, Данные)Экспорт 
	Если Событие="BarcodeDecodeData" тогда 
		Попытка
			/////-КостыльПоЗаводскимSSCC Присекам на корню
			ШК=Данные;
			ПривестиSSCCК18СимволамКлиент(ШК);
			/////////----------------------------------------
			Оповестить("ОбработчикШтрихКода",ШК,"ОбработчикШтрихКода");
			//Сообщить(Строка(Уведомление.Данные));
		исключение
			Оповестить("ОбработчикШтрихКода",404,"ОшибкаЧтения");
		КонецПопытки;
		//Оповестить("ОбработчикШтрихКода",404,"ист");
	КонецЕсли;
	КонецПроцедуры
#КонецОбласти

// Процедура - Сканирование камерой
//
// Параметры:
//  Форма						 - УправляемаяФорма - форма, в которую необходимо передать результат работы сканирования
//  АдресЭлементаФормы			 - Строка - реквизита формы 
//  ПроцедураОбработчикаНаФорме	 - Строка - Имя экспортной процедуры на форме, для обработки полученных данных ( без параметров )
//
Процедура СканированиеКамерой(Форма,АдресЭлементаФормы,ПроцедураОбработчикаНаФорме) Экспорт
	#Если МобильноеПриложениеКлиент  тогда

	Если НЕ СредстваМультимедиа.ПоддерживаетсяСканированиеШтрихКодов() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Сканирование штрихкодов не поддерживается");
		Возврат
	КонецЕсли;
	Параметры=новый Структура("Форма,АдресЭлементаФормы,ПроцедураОбработчикаНаФорме",Форма,АдресЭлементаФормы,ПроцедураОбработчикаНаФорме);
	ОбработчикСканирования = Новый ОписаниеОповещения("ОбработкаСканирования", МодульМобильныхДивайсовКлиент,Параметры);
	СредстваМультимедиа.ПоказатьСканированиеШтрихКодов("Сканируйте штрих код",ОбработчикСканирования);
	#КонецЕсли

КонецПроцедуры

// Процедура - Обработка сканирования
//
// Параметры:
//  Штрихкод				 - Строка	 -  Cканированный код.
//  Результат				 - Булево	 -   Возвращаемый параметр. Указывает, успешно ли сканирование.
//  Сообщение				 - Строка	 -  Возвращаемый параметр. Это сообщение будет отображено пользователю, чтобы проинформировать его о результатах последнего сканирования.
//  %Если сканирование не успешно, сообщение отображается красным цветом. 
//  %Если текст сообщения не задан, поведение различается в зависимости от успешности сканирования: 
//  %*Сканирование успешно – ничего не отображается. 
//  %*Сканирование не успешно - отображается сообщение "Ошибка обработки штрих-кода!"
//  ДополнительныеПараметры	 - Произвольный - дполнительные параметры
//
Процедура ОбработкаСканирования(Штрихкод, Результат, Сообщение, ДополнительныеПараметры)Экспорт 
	#Если МобильноеПриложениеКлиент  тогда

	Если Результат тогда
		ДополнительныеПараметры.Форма[ДополнительныеПараметры.АдресЭлементаФормы]=Штрихкод;
	КонецЕсли;
	СредстваМультимедиа.ЗакрытьСканированиеШтрихКодов();
	Выполнить("ДополнительныеПараметры.Форма."+ДополнительныеПараметры.ПроцедураОбработчикаНаФорме+"()");
	#КонецЕсли

КонецПроцедуры


Функция  РегистрацияБазыВСканереHoneyWell(ИдБазы="") Экспорт 
	Если ИдБазы="" Тогда
		ИдБазы=СлужебныеФункцииИПроцедурыКлиентСервер.ПолучитьЗначениеИдентификатораБазы();
	КонецЕсли;	
	#Если МобильноеПриложениеКлиент  тогда
        НовЗП = Новый ЗапускПриложенияМобильногоУстройства();
		НовЗП.Действие="com.HoneywellScan.action";
		НовЗП.ДополнительныеДанные.Добавить("IdBase",ИдБазы); //что сделать: Старт/Стоп
		Результат = НовЗП.Запустить(Истина);
		Возврат Результат;
	#КонецЕсли	
	Возврат Неопределено;
КонецФункции

// Функция - Идентификатор базы начало выбора
// получает УИД базы  
//
// Возвращаемое значение:
// Строка  -  УИД базы строкой
//
Функция  ИдентификаторБазыНачалоВыбора() Экспорт 
	
	#Если МобильноеПриложениеКлиент Тогда
		СЗ = Новый СписокЗначений;
		
		Базы = Новый ЧтениеТекста ("/data/data/com.e1c.mobile/files/1C/1cem/ibases.v8i");
		Стр = Базы.ПрочитатьСтроку();
		_Имя = ""; _ИД = "";
		Пока Стр <> Неопределено Цикл 
			Если Лев(Стр, 1) = "[" Тогда
				_Имя = Стр;
			КонецЕсли;
			Если Лев(Стр, 3) = "ID=" Тогда
				_ИД = СтрЗаменить(Стр,"ID=","");
				СЗ.Добавить(_ИД,_Имя);
			КонецЕсли;
			Стр = Базы.ПрочитатьСтроку();    
		КонецЦикла;
		Эл = СЗ.ВыбратьЭлемент();
		Возврат Эл.Значение;
		
	#КонецЕсли
	Возврат Неопределено;
КонецФункции

Функция  ПолучениеДанныхСистемнойИнформации(ИдБазы="") Экспорт 
	Если ИдБазы="" Тогда
		ИдБазы=СлужебныеФункцииИПроцедурыКлиентСервер.ПолучитьЗначениеИдентификатораБазы();
	КонецЕсли;	
	#Если МобильноеПриложениеКлиент  тогда
        НовЗП = Новый ЗапускПриложенияМобильногоУстройства();
		НовЗП.Действие="com.ben.getinfoserialnumber.action";
		НовЗП.ДополнительныеДанные.Добавить("IdBase",ИдБазы); //что сделать: Старт/Стоп
		Результат = НовЗП.Запустить(Истина);
		Возврат Результат;
	#КонецЕсли	
	Возврат Неопределено;
	КонецФункции
//@skip-warning
#Область ПроцедурыИФункцииДляСправки
//@skip-warning

Процедура ЗапуститьКомпонентуСканирования() Экспорт
	#Если МобильноеПриложениеКлиент  тогда
		////
		//НовЗП = Новый ЗапускПриложенияМобильногоУстройства();
		//НовЗП.Действие = "com.barcodeto1c.action";
		//НовЗП.ДополнительныеДанные.Добавить("ServiceState","Start"); //что сделать: Старт/Стоп
		//НовЗП.ДополнительныеДанные.Добавить("ServiceSCAN_MESSAGE","scan.rcv.message"); //чей бродкаст ловить
		//НовЗП.ДополнительныеДанные.Добавить("ServiceBarCodeField","barocode"); //в каком поле сканер возвращает штрих-код (если не задавать - по умолчанию barocode, что в большинстве случаев оно так)
		//НовЗП.ДополнительныеДанные.Добавить("ServiceEventID","1"); //категория сообщение для 1С
		//НовЗП.ДополнительныеДанные.Добавить("ServiceToast","Service STARTED!");//(не обязательно) просто покажет Тост при успехе
		//НовЗП.ДополнительныеДанные.Добавить("ServiceBase_Name",ИдентификаторБазыНачалоВыбора());//если одна база - можно поставить ""
		//Результат = НовЗП.Запустить(Истина);
		//////
		//
		//Если НЕ Результат = 77 Тогда
		//	//тут можно отловить что что-то не так. Возможно апк не установлена или что-то не сработало
		//КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры
//@skip-warning

Процедура ОстановитьКомпонентуСканирования() Экспорт
	#Если МобильноеПриложениеКлиент  тогда
		//
		//НовЗП = Новый ЗапускПриложенияМобильногоУстройства();
		//НовЗП.Действие = "com.barcodeto1c.action";
		//НовЗП.ДополнительныеДанные.Добавить("ServiceState","Stop");
		//НовЗП.ДополнительныеДанные.Добавить("ServiceToast","Service STOPED!");
		//Результат = НовЗП.Запустить(Истина);
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

Процедура ЗапуститьУстановкуДрайвераКлавиатуры() Экспорт 
СсылкаНаФайл = СлужебныеФункцииИПроцедурыКлиентСервер.ПолучитьДвоичныеДанныеДрайвера("ДрайверНажаияКлавиш");
ИмяФайлаВрем = "DraverKey.apk";
ВременныйКаталог = КаталогДокументов();
СсылкаНаФайл.Записать(ВременныйКаталог+ИмяФайлаВрем);
ЗапуститьПриложение(ВременныйКаталог+ИмяФайлаВрем);
//Сообщить(ВременныйКаталог+ИмяФайлаВрем);	
	КонецПроцедуры
#Область УстаревшийФункционал

// Процедура - Установка драйверов
// Устанавливает андроид компоненты для работы приложения
// Процедура - Установка драйверов штрих кода
// Установка драйвера приема штрих кода с оборудования
// Процедура - Регистрация базы в сканере honey well
// Регистрирует текущую ИБ как получатель в драйвере сканера
Процедура УстановкаДрайверов()Экспорт 
	Если СлужебныеФункцииИПроцедурыКлиентСервер.КомпанентаСканированияУстановлена() тогда
		Возврат
	КонецЕсли;	
	Адрес="";
	ИдБазыДляРегистрации=ИдентификаторБазыНачалоВыбора();
	СлужебныеФункцииИПроцедурыКлиентСервер.УстановитьИдентификаторБазы(ИдБазыДляРегистрации);
	УстановкаДрайверовШтрихКода(ИдБазыДляРегистрации,Адрес);
	УстановкаДрайвераСистемнойИнформации(ИдБазыДляРегистрации,Адрес);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Адрес);
	КонецПроцедуры


Процедура УстановкаДрайверовШтрихКода(ИдБазы="",Адрес)Экспорт 
	Если СлужебныеФункцииИПроцедурыКлиентСервер.КомпанентаСканированияУстановлена() тогда
		//ЗапуститьКомпонентуСканирования();
		Возврат
	КонецЕсли;	
	МассивДрайверов=новый Массив;
	МассивДрайверов.Добавить("BarcodeHoneywell");
	
	 для Каждого ИмяМакета из  МассивДрайверов цикл
	СсылкаНаФайл = СлужебныеФункцииИПроцедурыКлиентСервер.ПолучитьМакетДрайвера(ИмяМакета);
	ИмяФайлаВрем = ИмяМакета + ".apk";
	ВременныйКаталог = КаталогДокументов();
	Если ПолучитьФайл(СсылкаНаФайл, ВременныйКаталог + ИмяФайлаВрем, Ложь) Тогда
		 Адрес=Адрес+" 
		 |Адрес apk файлов: "+ВременныйКаталог + ИмяФайлаВрем;
			Иначе
		ТекстОшибки = НСтр("ru='Ошибка установки драйвера.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки); 
	КонецЕсли;
	КонецЦикла;

КонецПроцедуры


Процедура УстановкаДрайвераСистемнойИнформации(ИдБазы="",Адрес)
	Если СлужебныеФункцииИПроцедурыКлиентСервер.КомпанентаСканированияУстановлена() тогда
		//ЗапуститьКомпонентуСканирования();
		Возврат
	КонецЕсли;	
	МассивДрайверов=новый Массив;
	МассивДрайверов.Добавить("ServiseInformation");
	
	 для Каждого ИмяМакета из  МассивДрайверов цикл
	СсылкаНаФайл = СлужебныеФункцииИПроцедурыКлиентСервер.ПолучитьМакетДрайвера(ИмяМакета);
	ИмяФайлаВрем = ИмяМакета + ".apk";
	ВременныйКаталог = КаталогДокументов();


	//КаталогВременныхФайлов();
	Если ПолучитьФайл(СсылкаНаФайл, ВременныйКаталог + ИмяФайлаВрем, Ложь) Тогда
		Адрес=Адрес+"
		|Адрес apk файлов: "+ВременныйКаталог + ИмяФайлаВрем;
	Иначе
		ТекстОшибки = НСтр("ru='Ошибка установки драйвера.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки); 
	КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти