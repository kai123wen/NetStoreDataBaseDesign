---郭振豪

--创建店铺工作人员表
CREATE TABLE storeStaff (
	staffID number(16) PRIMARY KEY,
	staffNickName varchar2(20) NOT NULL,
	staffAccount varchar2(16) NOT NULL,
	staffPassword varchar2(16) NOT NULL,
	staffStatus varchar2(20) NOT NULL,
	age int DEFAULT 18 NOT NULL,
	CHECK (age >= 18)
)


  --创建序列
  
  create sequence seq_storeStaff
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;

	
create or replace trigger tri_storeStaff
    before insert on storeStaff
    for each row
declare
    nextid number(16);
begin
    if :new.staffID is null or :new.staffID = 0 then
        select seq_storeStaff.Nextval
        into nextid
        from sys.dual;
        :new.staffID := nextid;
    end if;
end tri_storeStaff;



--创建顾客表
CREATE TABLE customer (
	customerID number(16) PRIMARY KEY,
	customerNickName varchar2(20) NOT NULL,
	customerHeadPic varchar2(20) DEFAULT '平台默认头像URL' NOT NULL,
	customerAccount varchar2(16) NOT NULL,
	customerPassword varchar2(16) NOT NULL,
	customerAddress varchar2(100) NOT NULL,
	customerPhone number(11) NOT NULL,
	age int DEFAULT 18 NOT NULL,
	CHECK (age >= 18)
)

    --创建序列
  create sequence seq_customer
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;

create or replace trigger tri_customer
    before insert on customer
    for each row
declare
    nextid number(16);
begin
    if :new.customerID is null or :new.customerID = 0 then
        select seq_customer
        into nextid
        from sys.dual;
        :new.customerID := nextid;
    end if;
end tri_customer;

--创建平台管理人员表
CREATE TABLE platformAd (
	adID number(16) PRIMARY KEY,
	adNickName varchar2(20) NOT NULL,
	adAccount varchar2(16) NOT NULL,
	adPassword varchar2(20) NOT NULL
)

     --创建序列
  create sequence seq_platformAd
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;
	
create or replace trigger tri_platformAd
    before insert on platformAd
    for each row
declare
    nextid number(16);
begin
    if :new.adID is null or :new.adID = 0 then
        select seq_platformAd
        into nextid
        from sys.dual;
        :new.adID := nextid;
    end if;
end tri_platformAd;




--创建订单表
CREATE TABLE orderForm (
	orderID number(16) PRIMARY KEY,
	customerID number(16) NOT NULL,
	orderTime date NOT NULL,
	orderRemark varchar2(500),
	orderSure int DEFAULT 0 NOT NULL,
	address varchar2(100) NOT NULL,
	goodTotalPrice number(8,2) not null,
	CHECK (orderSure = 1
		OR orderSure = 0)
)


--添加外键

alter table orderForm add constraint fk_orderForm foreign key(customerID) references customer(customerID);

 --创建序列
  create sequence seq_orderForm
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;

create or replace trigger tri_orderForm
    before insert on orderForm
    for each row
declare
    nextid number(16);
begin
    if :new.orderID is null or :new.orderID = 0 then
        select seq_orderForm.Nextval
        into nextid
        from sys.dual;
        :new.orderID := nextid;
    end if;
end tri_orderForm;




--创建商品表
CREATE TABLE good (
	goodID number(16) PRIMARY KEY,
	goodName varchar2(20) NOT NULL,
	goodIntroduction varchar2(20) NOT NULL,
	goodPutAwayTime date NOT NULL,
	setID number(16) NOT NULL,
	classID number(16) NOT NULL,
	goodVolume number(10) NOT NULL
)

--创建外键
alter table good add constraint fk_good_goodBrandList foreign key (setID) references goodBrandList(setsID);

alter table good add constraint fk_good_goodCategory foreign key(classID) references goodCategory(categoryID);

 --创建序列
  create sequence seq_good
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;

create or replace trigger tri_good
    before insert on good
    for each row
declare
    nextid number(16);
begin
    if :new.goodID is null or :new.goodID = 0 then
        select seq_good
        into nextid
        from sys.dual;
        :new.goodID := nextid;
    end if;
end tri_good;

--创建平台管理员-商品表
CREATE TABLE PlatformAdmi_Good (
	goodID number(16),
	adID number(16),
	PRIMARY KEY (goodID, adID)
)


--创建商品分类-商品表
CREATE TABLE GoodCategory_Goood (
	goodCategoryID number(16),
	goodID number(16),
	PRIMARY KEY (goodCategoryID, goodID)
)


-----高培峰


--创建购物车表
CREATE TABLE shoppingCart (
	customerID number(16),
	goodNumber int DEFAULT 0 NOT NULL,
	goodSKUID number(16),
	CHECK (goodNumber >= 0),
	PRIMARY KEY (customerID, goodSKUID)
)

--创建评论表
CREATE TABLE comments (
	customerID number(16) NOT NULL,
	goodID Varchar2(16) NOT NULL,
	commentContent Varchar2(500),
	commentTime date NOT NULL,
	judgeLevel int DEFAULT 0 NOT NULL,
	browseTimes int DEFAULT 0 NOT NULL,
	PRIMARY KEY (customerID, goodID),
	CHECK (judgeLevel >= 0
		AND browseTimes >= 0)
)

--创建商品分类表
CREATE TABLE goodCategory (
	categoryID number(16) PRIMARY KEY,
	categoryName Varchar2(11) NOT NULL
)


 --创建序列
  create sequence seq_goodCategory
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;

create or replace trigger tri_goodCategory
    before insert on goodCategory
    for each row
declare
    nextid number(16);
begin
    if :new.categoryID is null or :new.categoryID = 0 then
        select seq_goodCategory
        into nextid
        from sys.dual;
        :new.categoryID := nextid;
    end if;
end tri_goodCategory;




--创建每条消息记录表
CREATE TABLE chattingRecords (
	recordsID number(16) PRIMARY KEY,
	chattingRecordsTime date NOT NULL,
	customerID number(16) NOT NULL references customer(customerID),
	workerID number(16) NOT NULL references storeStaff(staffID),
	comminicationContent Varchar2(500) NOT NULL,
	allChatRecordID number(16) not null references allChatRecord(allChatRecordID)
)

 --创建序列
  create sequence seq_chattingRecords
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;



create or replace trigger tri_chattingRecords
    before insert on chattingRecords
    for each row
declare
    nextid number(16);
begin
    if :new.recordsID is null or :new.recordsID = 0 then
        select seq_chattingRecords
        into nextid
        from sys.dual;
        :new.recordsID := nextid;
    end if;
end tri_chattingRecords;





--创建聊天记录表
create table allChatRecord(
	allChatRecordID number(16) primary key
)

 --创建序列
  create sequence seq_allChatRecord
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;





create or replace trigger tri_allChatRecord
    before insert on allChatRecord
    for each row
declare
    nextid number(16);
begin
    if :new.allChatRecordID is null or :new.allChatRecordID = 0 then
        select seq_allChatRecord
        into nextid
        from sys.dual;
        :new.allChatRecordID := nextid;
    end if;
end tri_allChatRecord;





--创建外键
alter table chattingRecords add constraint fk_chattingRecords_customer foreign key(customerID) references customer(customerID)

alter table chattingRecords add constraint fk_chattingRecords_storeStaff foreign key(workerID) references storeStaff(staffID)

alter table chattingRecords add constraint fk_chattingRecords_good foreign key(comminicationGoodID) references good(goodID)





--创建商品-图片表
CREATE TABLE Good_Image (
	goodID number(16),
	imageURL Varchar2(200) NOT NULL,
	goodSKUID number(16),
	PRIMARY KEY (goodID, goodSKUID)
)



--创建商品品牌系列表
CREATE TABLE goodBrandList (
	setsID number(16) PRIMARY KEY,
	brandName Varchar2(20) NOT NULL,
	describe Varchar2(500) NULL,
	logoURL Varchar2(200) NOT NULL
)




 --创建序列
  create sequence seq_goodBrandList
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;




create or replace trigger tri_goodBrandList
    before insert on goodBrandList
    for each row
declare
    nextid number(16);
begin
    if :new.setsID is null or :new.setsID = 0 then
        select seq_goodBrandList
        into nextid
        from sys.dual;
        :new.setsID := nextid;
    end if;
end tri_goodBrandList;





---孙睿

--创建购物车-商品SKU表
CREATE TABLE Shopingcart_GoodsSKU (
	goodSKUID number(16) NOT NULL,
	goodID number(16) NOT NULL,
	PRIMARY KEY (goodSKUID, goodID)
)



--创建商品标签表
CREATE TABLE goodLable (
	labelID number(16) PRIMARY KEY,
	lableName Varchar2(50) NOT NULL
)


 --创建序列
  create sequence seq_goodLable
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;

create or replace trigger tri_goodLable
    before insert on goodLable
    for each row
declare
    nextid number(16);
begin
    if :new.labelID is null or :new.labelID = 0 then
        select seq_goodLable
        into nextid
        from sys.dual;
        :new.labelID := nextid;
    end if;
end tri_goodLable;

--创建商品-标签表
CREATE TABLE Goods_Label (
	goodsID number(16),
	lableID number(16),
	PRIMARY KEY (goodsID, lableID)
)


--创建规格参数表
CREATE TABLE specificationParameter (
	goodsSKUID number(16) PRIMARY KEY,
	specificationParameter Varchar2(50) NOT NULL,
	packingIist Varchar2(50) NOT NULL
);

 --创建序列
  create sequence seq_specificationParameter
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;

create or replace trigger tri_specificationParameter
    before insert on specificationParameter
    for each row
declare
    nextid number(16);
begin
    if :new.goodsSKUID is null or :new.goodsSKUID = 0 then
        select seq_specificationParameter.Nextval
        into nextid
        from sys.dual;
        :new.goodsSKUID := nextid;
    end if;
end tri_specificationParameter;





--创建商品预约表
CREATE TABLE appointment (
	goodSKUID number(16),
	customerID number(16),
	appointmentIntroduction Varchar2(50),
	appointmentDeposit number(8, 2) DEFAULT 0 NOT NULL,
	createTime date,
	CONSTRAINT ck_number CHECK (appointmentDeposit >= 0),
	PRIMARY KEY (goodSKUID, customerID)
)


--创建退货表
CREATE TABLE refund (
	refundID number(16) PRIMARY KEY,
	orderID number(16) NOT NULL,
	refundTime date NOT NULL
)

--创建外键

alter table refund add constraint fk_refund_orderForm foreign key(orderID) references orderForm(orderID)

 --创建序列
  create sequence seq_refund
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;



create or replace trigger tri_refund
    before insert on refund
    for each row
declare
    nextid number(16);
begin
    if :new.refundID is null or :new.refundID = 0 then
        select seq_refund.nextval
        into nextid
        from sys.dual;
        :new.refundID := nextid;
    end if;
end tri_refund;





---宋维晓

-- 优惠活动表

create table onSaleActivity(
    activityID      number(16)      primary key,
    startTime       Date            not null,
    endTime         Date            not null,
    discount        Binary_float    not null        check (discount between 0 and 1)
)



 --创建序列
  create sequence seq_onSaleActivity
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;




create or replace trigger tri_onSaleActivity
    before insert on onSaleActivity
    for each row
declare
    nextid number(16);
begin
    if :new.activityID is null or :new.activityID = 0 then
        select seq_onSaleActivity.Nextval
        into nextid
        from sys.dual;
        :new.activityID := nextid;
    end if;
end tri_onSaleActivity;




-- 活动-商品表

create table Activity_Goods(
    goodsID         number(16)      not null,
    activityID      number(16)      not null,
	primary key(goodsID,activityID)
);

-- 商品-订单表

create table Goods_Order(
    orderID		    number(16)      not null,  
    goodsSKUID      number(16)      not null,   
	goodQty			int 			not null,
	wareHouseID		number(16)		not null,
	primary key(orderID,goodsSKUID)
);





-- 店铺粉丝表

create table storeFans(
    fansID          number(16)      primary key,
    fansNickName    number(20)      not null
);



-- 服务表

create table goodService(
    serviceID       number(16)      primary key,
    goodsOrderID    number(16)      not null,   -- foreign key
    serviceTypeID   number(16)      not null,
    startTime       number(16)      not null,
);




--创建外键
alter table goodService add constraint fk_goodService_orderForm foreign key(goodsOrderID) references orderForm(orderID)
alter table goodService add constraint fk_goodService_serviceType foreign key(serviceTypeID) references serviceType(typeID)

 --创建序列
  create sequence seq_goodService
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;





create or replace trigger tri_service
    before insert on goodService
    for each row
declare
    nextid number(16);
begin
    if :new.serviceID is null or :new.serviceID = 0 then
        select seq_service.nextval
        into nextid
        from sys.dual;
        :new.serviceID := nextid;
    end if;
end tri_service;





-- 服务类型

create table serviceType(
    typeID          number(16)      primary key,
    introduction    varchar2(500)    not null,
	serviceTimeLength int			not null,
);



 --创建序列
  create sequence seq_serviceType
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;




create or replace trigger tri_serviceType
    before insert on serviceType
    for each row
declare
    nextid number(16);
begin
    if :new.typeID is null or :new.typeID = 0 then
        select seq_serviceType.Nextval
        into nextid
        from sys.dual;
        :new.typeID := nextid;
    end if;
end tri_serviceType;





--段逸霖


--创建换货单表
create table swapGood(
	swapOrderID		number(16)		primary key,
	orderID			number(16)		not null,
	swapTime		date			not null,
	reason			varchar2(500)	not null
);

--创建外键

swapGood

alter table swapGood add constraint fk_swapGood_order foreign key (orderID) references orderForm(orderID)


 --创建序列
  create sequence seq_swapGood
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;




create or replace trigger tri_swapGood
    before insert on swapGood
    for each row
declare
    nextid number(16);
begin
    if :new.swapOrderID is null or :new.swapOrderID = 0 then
        select seq_swapGood.Nextval
        into nextid
        from sys.dual;
        :new.swapOrderID := nextid;
    end if;
end tri_swapGood;






--创建仓库表
create table wareHouse(
	warehouseID		number(16)	  	primary key,
	adress			  varchar2(100)	  not null
);




 --创建序列
  create sequence seq_wareHouse
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;



create or replace trigger tri_wareHouse
    before insert on wareHouse
    for each row
declare
    nextid number(16);
begin
    if :new.warehouseID is null or :new.warehouseID = 0 then
        select seq_wareHouse.Nextval
        into nextid
        from sys.dual;
        :new.warehouseID := nextid;
    end if;
end tri_wareHouse;




--创建发票表
create table invoice(
	invoiceID		number(16)		primary key,
	orderID			number(16)		not null,
	context			varchar2(500)	not null
);

--创建外键
alter table invoice add constraint fk_invoice_orderForm foreign key(orderID) references orderForm(orderID)





 --创建序列
  create sequence seq_invoice
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;



create or replace trigger tri_invoice
    before insert on invoice
    for each row
declare
    nextid number(16);
begin
    if :new.invoiceID is null or :new.invoiceID = 0 then
        select seq_invoice.nextval
        into nextid
        from sys.dual;
        :new.invoiceID := nextid;
    end if;
end tri_invoice;






--创建商品-仓库表
create table Goods_Warehouse(
	goodSKUID		number(16)	,
	warehouseID		number(16)	,
	quantity		int		default 0	not null,
	check (quantity >= 0),primary key(goodSKUID,warehouseID)
);





--创建商品收藏表
create table goodCollection(
	customerID		number(16)	,
	goodID			number(16)	,primary key(customerID,goodID)
);



--创建商品SKU表

create table goodSKU(
	goodSKUID		number(16)		primary key,
	goodID			number(16)		not null,
	currentPrice	number(8,2)		default 0 not null,
	origionalPrice	number(8,2)		default 0 not null,
	shopPoint		int		default 0	not null ,	check (shopPoint >= 0 and currentPrice>=0 and origionalPrice >=0)
);




--添加外键
alter table goodSKU add constraint fk_goodSKU_good foreign key(goodID) references good(goodID)




 --创建序列
  create sequence seq_goodSKU
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;




create or replace trigger tri_goodSKU
    before insert on goodSKU
    for each row
declare
    nextid number(16);
begin
    if :new.goodSKUID is null or :new.goodSKUID = 0 then
        select seq_goodSKU.Nextval
        into nextid
        from sys.dual;
        :new.goodSKUID := nextid;
    end if;
end tri_goodSKU;





---设置游标

	--设置 查看在某一价格区间里的某一特定商品分类的商品 的游标
	declare 
		cursor cu_findGoodByPrice(low in number, high in number, keywords in varchar2) is
		select * 
		from good  G
		where( (keywords = goodName)
			and (low < any (select currentPrice from goodSKU where goodID = G.goodID))
			and (high >= any (select currentPrice from goodSKU where goodID = G.goodID)));

	begin
		open cu_findGoodByPrice(10,40);
		
		close cu_findGoodByPrice;
	end;




	--设置 查看某个商品不同等级的评价 的游标
	declare
		cursor cu_findCommentByLevel(level number, gID number)
		is
		select *
		from comments
		where judgeLevel = level and gID = goodID;



	--设置 按照商品价格排序从高到低排序 的游标
	declare
		cursor cu_sortGoodByPriceFromHighToLow(keyWords varchar2)
		is
		select *
		from goodSKU
		where %keywords% = goodName
		order by currentPrice desc

	--设置 按照商品价格排序从低到高排序 的游标
	declare
		cursor cu_sortGoodByPriceFromLowToHigh(keyWords varchar2)
		is
		select *
		from goodSKU
		where %keywords% = goodName
		order by currentPrice desc

	--设置 按照商品评价从高到低排序 的游标
	declare
		cursor cu_sortCommentsByLevel(gID number)
		is
		select *
		from comments
		where goodID = gID
		order by currentPrice desc

	--设置 查看某一时间段内产生的订单 的游标
	declare
		cursor cu_findOrderByTime(startTime Date, endTime Date, cID number)
		is
		select *
		from orderForm
		where orderTime > startTime and orderTime <= endTime and cID = customerID;


	--设置 查看全部订单按照时间从后向前排序 的游标
	declare
		cursor cu_sortOrderByTime(cID number)
		is
		select *
		from orderForm
		where cID = customerID
		order by orderTime desc;

	--设置 查看购物车 的游标
	declare
		cursor cu_displayShoppingCart(cID number)
		is
		select *
		from shoppingCart
		where cID = customerID;

	--设置 查看新上架商品 的游标
	declare
		cursor cu_findGoodByTime(d Date, keywords varchar2)
		is
		select *
		from %keywords% = goodName
		order by goodPutAwayTime desc;






--触发器

	--序列 ok



	--订单地址
create or replace trigger tri_orderForm_address
    before insert on orderForm
    for each row
declare
    address varchar2(100);
begin
    if :new.address is null then
    select CustomerAddress
    into address
    from customer
    where customerID = :new.customerID;
  end if;
  :new.address := address;
end tri_orderForm_address;



	--自动更新所有货物的评级
create or replace trigger tri_level
    after insert on comments
    for each row
declare
    level int;
begin
    select avg(judgeLevel)
    into level
    from comments
    where goodID = :new.goodID
    group by goodID;

    update good
    set goodLevel = level
    where goodID = :new.goodID;
end tri_level;





	--时间（分为创建和修改）
		--商品上架时间
create or replace trigger tri_good_time
    before insert on good
    for each row
begin
   if :new.goodPutAwayTime is null then
    select sysdate
    into  :new.goodPutAwayTime
    from dual;
  end if;
end tri_good_time;




		--聊天记录创建时间
create or replace trigger tri_chattingRecords_time
    before insert on chattingRecords
    for each row
begin
    if :new.chattingRecordsTime = null then
		:new.chattingRecordsTime = sysdate;
	end if;
end tri_chattingRecords_time;




		--评论时间
create or replace trigger tri_comments_time
    before insert on comments
    for each row
begin
    if :new.commentTime = null then
		:new.commentTime = sysdate;
	end if;
end tri_comments_time;




		--订单创建时间
create or replace trigger tri_orderForm_time
    before insert on orderForm
    for each row
begin
    if :new.orderTime is null then
    select sysdate
    into :new.orderTime
    from dual;
  end if;
end tri_orderForm_time;




		--退货时间
create or replace trigger tri_refund_time
    before insert on refund
    for each row
begin
    if :new.refundTime is null then
    select sysdate
    into :new.refundTime
    from dual;
  end if;
end tri_refund_time;



		--换货时间
create or replace trigger tri_swapGood_time
    before insert on swapGood
    for each row
begin
    if :new.swapTime is null then
    select sysdate
    into :new.swapTime
    from dual;
  end if;
end tri_swapGood_time;




		--商品预约表创建时间
create or replace trigger tri_appointment_time
    before insert on appointment
    for each row
begin
    if :new.createTime = null then
		:new.createTime = sysdate;
	end if;
end tri_appointment_time;





-- 	--评价浏览次数
-- create or replace trigger tri_appointment_time
--     before select on appointment
--     for each row
-- begin
--     :new.browseTimes := :new.browseTimes + 1;
-- end tri_appointment_time;




	--商品购买后 检查库存 销量+1 库存-1
create or replace trigger tri_Goods_Order_time
    before insert on Goods_Order
    for each row
declare
	num int;
	ID number(16);
begin
	-- 从仓库中找到当前剩余库存量
	select quantity
  into num
  from Goods_WareHouse  GW
  where GW.wareHouseID = :new.wareHouseID ;

  --检查库存量是否充足
  if num - :new.GoodQty < 0 then
    raise_application_error(-20999, 'Dont have enough goods');
  end if;

  --更新仓库库存量
  update Goods_WareHouse  GW
  set quantity = quantity - :new.GoodQty
  where GW.wareHouseID = :new.wareHouseID;

  --更新
  select GoodSKUID
  into ID
  from GoodSKU GS
  where GS.goodSKUID = :new.goodsSKUID;

  update Good  GW
  set goodVolume = goodVolume + :new.GoodQty
  where GoodID = ID;

end tri_Goods_Orders_time;





	--订单总价
create or replace trigger tri_OrderForm_total
    before insert on OrderForm
    for each row
declare
  price number(8, 2);
begin
  select sum(GoodQty * currentPrice)
  into price
  from Goods_Order
  left join goodSKU
  on Goods_Order.Goodsskuid = Goodsku.Goodskuid
  where ORDERID = :new.orderID;

  :new.goodTotalPrice := price;

end tri_OrderForm_total;




	--服务时间合法性检查
create or replace trigger tri_goodService_check
  before insert on goodService
  for each row
declare
  startTime Date;
  length Int;
begin
  select orderTime
  into startTime
  from OrderForm form
  where form.orderID = :new.Goodsorderid;

  select serviceTimeLength
  into length
  from serviceType
  where typeID = :new.serviceTypeID;

  if sysdate > startTime + length then
    raise_application_error(-20999, 'service Time exceed.');
   end if;

end tri_goodService_check;



	
	--退货时间合法性检查
create or replace trigger tri_refund_check
  before insert on refund
  for each row
declare
  startTime Date;
begin
  select orderTime
  into startTime
  from OrderForm
  where orderID = :new.orderID;

  if sysdate > startTime + 7 then
    raise_application_error(-20999, 'Time exceed.');
   end if;
end tri_refund_check;





	--换货时间合法性检查
create or replace trigger tri_swapGood_check
  before insert on swapGood
  for each row
declare
  startTime Date;
begin
  select orderTime
  into startTime
  from OrderForm
  where orderID = :new.orderID;

  if sysdate > startTime + 30 then
    raise_application_error(-20999, '[Cant swapGood] Time exceed.');
  end if;

end tri_swapGood_check;




	--系统操作信息触发器
create table logInfo(
	logID		number(16)			primary key,
	dbUser		varchar2(10)		not null,
	act			varchar2(50)		not null,
	time		date				not null
);

create sequence seq_logInfo
	increment  by 1
	start with 1
	minvalue 1
	nomaxvalue
	nocycle
	nocache;



create or replace trigger tri_logInfo
    before insert on logInfo
    for each row
declare
    nextid number(16);
begin
    if :new.logID is null or :new.logID = 0 then
        select seq_logInfo.Nextval
        into nextid
        from sys.dual;
        :new.logID := nextid;
    end if;
end tri_logInfo;




		-- 数据库开闭触发器
		create or replace trigger tri_operation
  after startup  on database
begin
  insert 
  into logInfo(dbUser, act, time)
  select sys.login_user, ora_sysevent ,sysdate
  from dual;
end tri_operation;


create or replace trigger tri_operation
  before shutdown  on database
begin
  insert 
  into logInfo(dbUser, act, time)
  select sys.login_user, ora_sysevent ,sysdate
  from dual;
end tri_operation;








-- 函数


	-- 实现乘法和
create or replace function multi_money(price int,quantity number(16))
return int as 
begin 
declare out int;
begin
  out:=price*quantity;
  return out;
end;
end;

	-- 通过ID查询顾客信息，订单信息，商品信息
create or replace function select_good_from_goodID(goodID number(16))
return varchar as 
begin 
declare out varchar2(1000);
begin
  for i in (select * from good where goodID=good.goodID ) loop
  	out:=i.goodID||','||i.goodName||','||i.goodIntroductin||','||i.goodType||','||i.goodVolume||',';
  end loop;
  return out;
end;
end;
	-- 根据品牌系列查询商品
create or replace function select_goodID_from_setID(setID number(16))
return varchar as 
begin 
declare out varchar2(1000);
begin
  for i in (select * from good where setID=good.setID ) loop
  	out:=i.goodID||',';
  end loop;
  return out;
end;
end;
	-- 统计某一时间段销售金额
create or replace function select_money_from_date(A date ,B date )
return number as 
begin 
declare out number(4) ;
begin
  out:=0
  for i in (select * from orderForm,Goods_Order,goodsSKU where A<orderForm.orderTime and B>orderForm.orderTime and Goods_Order.orderID=orderForm.orderID and goodsSKU.goodsSKUID=Goods_Order.goodsSKUID ) loop
  	out:=out+i.origionalPrice;
  end loop;
  return out;
end;
end;
	-- 统计某一时间段某商品销售数量
create or replace function select_num_from_date(good_ID goodsID,A date ,B date )
return number as 
begin 
declare out number(4) ;
begin
  out:=0
  for i in (select * from orderForm,Goods_Order,goodsSKU where A<orderForm.orderTime and B>orderForm.orderTime and Goods_Order.orderID=orderForm.orderID and goodsSKU.goodsSKUID=Goods_Order.goodsSKUID ) loop
  	if i.goodsID = good_ID then 
  	out:=out+1;
  	end if;
  end loop;
  return out;
end;
end;




-- 存储过程


	-- 订单-商品
create or replace procedure Insert_Goods_Order
(Goods_Order_items in Goods_Order_item_arr,
 orderID_ in number(16),
 customerId_ in number(16),
 orderTime_ in date,
 orderRemark_ in Varchar2(500),
 orderSure_ in int) 
 is
 
 create or replace type Goods_Order_item asobject(
goodsSKUID number(16),
orderID number(16)
);
--建立一个商品-订单条目的数组
create or replace Goods_Order_item_arr as table of Goods_Order_item
--建立存储过程
 
 i number;
begin
  --在订单表中插入
  insert into orderForm(orderID,customerId,orderTime,orderRemark,orderSure)
                values(orderID_,customerId_,orderTime_,orderRemark_,orderSure_);
  --在订单-商品中插入
  for i in 1 .. Goods_Order_items.count loop 
    insert into Goods_Order(goodsSKUID,orderID)
                values(Goods_Order_items(i).goodsSKUID,Goods_Order_items(i).orderID);
  end loop;
end Insert_Goods_Order; 






	--商品-收藏
--建立存储过程
create or replace procedure Insert_Goods_Warehouse
(goodsSKUID_ in number(16),
 warehouseID_ in number(16),
 quantity_ in int,
 adress_ in Varchar2(100)
)
 as
begin
  --在商品-仓库表中插入
  insert intoGoods_Warehouse(goodsSKUID , warehouseID,quantity )
                values(goodsSKUID_ , warehouseID_,quantity_);
  --在仓库中插入
  insert into wareHouse(warehouseID,adress)
                values(warehouseID_,adress_ );
end Insert_Goods_Warehouse; 





	-- 活动-商品
--建立存储过程
create or replace procedure Insert_OnSaleActivity
(activityID_ in number(16),
 startTime_ in  Date,
 endTime_ in Date,
 discount_ in Binary_float,
 goodsID_ in number(16)
)
 as
begin
  --在优惠活动表表中插入
  insert into OnSaleActivity(activityID , startTime,endTime,discount)
                values(activityID_ , startTime_,endTime_,discount_);
  --在活动-商品中插入
  insert into Activity_Goods(goodsID,activityID )
                values(goodsID_,activityID_ );
end Insert_OnSaleActivity; 




	-- 开始聊天
--建立存储过程
create or replace procedure Insert_chattingRecords
(recordsID_ in number(16),
 chattingRecordsTime_ in  Date,
 customerID_ in number(16),
 workerID_ in number(16) ,
 comminicationGoodID in number(16)
 comminicationContent in Varchar2(500)
)
 as
begin
  --在优惠活动表表中插入
  insert into OnSaleActivity(activityID , startTime,endTime,discount)
                values(activityID_ , startTime_,endTime_,discount_);
  --在活动-商品中插入
  insert into Activity_Goods(goodsID,activityID )
                values(goodsID_,activityID_ );
end Insert_OnSaleActivity; 




	-- SKU-*
--建立存储过程
create or replace procedure Insert_Goods_Warehouse
(goodsSKUID_ in number(16),
 warehouseID_ in number(16),
 quantity_ in int,
 adress_ in Varchar2(100)
)
 as
begin
  --在商品-仓库表中插入
  insert intoGoods_Warehouse(goodsSKUID , warehouseID,quantity )
                values(goodsSKUID_ , warehouseID_,quantity_);
  --在仓库中插入
  insert into wareHouse(warehouseID,adress)
                values(warehouseID_,adress_ );
end Insert_Goods_Warehouse; 



---视图


--查看员工信息
create view view_storeStaff
as
select staffID,staffNickName,staffStatus,age
from storeStaff
with read only

--查看顾客信息
create view view_customer
as
select customerID,customerNickName,customerAccount,customerAddress,customerPhone,age
from customer
with read only

--查看平台管理员信息
create view view_platformAdim
as
select adID,adNickname,adAccount
from platformAdmi
with read only

--查看订单信息
create view view_orderForm
as
select o.orderID,o.customerID, c.customerNickName, c.customerAddress, c.customerPhone, o.orderTime,o.orderSure
from orderForm o,customer c
where o.customerID = c.customerID
group by orderID,o.customerID, c.customerNickName, c.customerAddress, c.customerPhone, orderTime,orderSure
with read only



--查看平台管理员和商品的管理关系信息
create view view_PlatformAdmi_Good
as
select pg.goodID, g,goodName, pg.adID, pa.adAccount, pa.adNickName
from PlatformAdmi_Good pg, platformAdmi pa,good g
where pg.goodID = good.ID and pg.adID = pa.adID
group by pg.goodID, g,goodName, pg.adID, pa.adAccount, pa.adNickName
with read only




--查看换货单信息
create view view_swapGood
as
select s.swapOrderID, s.orderID, form.customerID, c.customerNickName, s.swapTime
from Swapgood s, orderForm form, customer c
where s.orderID = form.orderID and form.customerID = c.customerID
group by s.swapOrderID, s.orderID, form.customerID, c.customerNickName, s.swapTime
with read only




--查看仓库地址信息
create view view_warehouse
as
select warehouseID,adress
from warehouse
with read only




--查看发票信息
create view view_invoice
as
select invoiceID, i.orderID, gs.goodID, g.goodName, go.goodQty, o.customerID, c.customerNickName, o.orderTime
from invoice i,orderForm o,customer c, Goods_Order go, goodSKU gs, good g
where i.orderID = o.orderID and o.customerID = c.customerId and o.orderID = go.orderID and go.goodsSKUID = gs.goodSKUID and gs.goodID = g.goodID
group by invoiceID, i.orderID, gs.goodID, g.goodName, go.goodQty, o.customerID, c.customerNickName, o.orderTime
with read only



--查看商品库存信息
create view view_Goods_Warehouse
as
select gw.goodskuid, gw.warehouseID, w.adress, gw.quantity
from Goods_Warehouse gw,goodSKU gs, wareHouse w
where gw.warehouseID = w.warehouseID and gw.goodskuid = gs.goodSKUID
group by  gw.goodskuid, gw.warehouseID, w.adress, gw.quantity
with read only



--查看收藏夹
create view view_goodCollection
as
select gc.customerID, c.customerNickName, gc.goodID, g.goodName
from goodCollection gc, good g, customer c
where gc.goodID = g.GoodID and gc.customerID = c.customerID
group by gc.customerID, c.customerNickName, gc.goodID, g.goodName
with read only



--查看商品品类信息 
create view view_goodSKU
as
select gs.goodSKUID, gs.goodID, g.goodName, sp.specificationParameter, gbl.brandName, g.goodPutAwayTime, gs.currentPrice, gs.origionalPrice, gs.shopPoint
from goodSKU gs, good g, goodBrandList gbl， specificationParameter sp
where gs.goodId = g.goodID and gs.goodSKUID = sp.goodsSKUID and g.setID = gbl.setsID
group by gs.goodSKUID, gs.goodID, g.goodName, sp.specificationParameter, gbl.brandName, g.goodPutAwayTime, gs.currentPrice, gs.origionalPrice, gs.shopPoint
with read only




--查看购物车
create view view_shoppingCart
as
select sc.customerID, c.customerNickName, sc.goodSKUID, g.goodName, sp.specificationParameter, gs.currentPrice, sc.goodNumber
from shoppingCart sc, Shopingcart_GoodsSKU sg, goodSkU gs, specificationParameter sp, customer c, good g
where sg.goodSKUID = sc.goodSKUID and sc.customerID = c.customerID and sg.goodSKUID = gs.goodSKUID and gs.goodSKUID = sp.goodsSKUID and gs.goodID = g.goodID
group by sc.customerID, c.customerNickName, sc.goodSKUID, g.goodName, sp.specificationParameter, gs.currentPrice, sc.goodNumber
with read only




--查看促销商品
create view view_Activity_Goods
as
select ag.activityID, ag.goodsID, oa.startTime, oa.endTime,oa.discount, gs.currentPrice
from Activity_Goods ag, OnSaleActivity oa, goodSKU gs
where ag.activityID = oa.activityID and ag.goodsID = gs.goodID
group by ag.activityID, ag.goodsID, oa.startTime, oa.endTime,oa.discount, gs.currentPrice
with read only



--查看售后单
create view view_goodService
as
select gs.serviceID,gs.serviceTypeID, gs.startTime, st.serviceTimeLength, gs.goodsOrderID,go.goodsSKUID, g.goodName, currentPrice, go.goodQty, c.customerID, c.customernickname
from goodService gs, serviceType st, goodSKU gsk,Goods_Order go, orderForm form, customer c,good g
where gs.goodsOrderId = go.orderId and go.orderID = form.orderID and form.customerID = c.customerID and go.goodsSKUID = gsk.goodSKUID and gs.serviceTypeID = st.typeID and gsk.goodID = g.goodID
group by gs.serviceID,gs.serviceTypeID, gs.startTime, st.serviceTimeLength, gs.goodsOrderID,go.goodsSKUID, g.goodName, currentPrice, go.goodQty, c.customerID, c.customernickname
with read only





--退货单
create view view_refund
as 
select r.refundID, r.orderID, form.customerID, c.customerPhone, form.orderTime, gs.goodSKUID, g.goodName,sp.specificationParameter, gs.currentPrice, go.goodQty
from refund r, orderForm form, customer c, Goods_Order go, goodSKU gs, good g, specificationParameter sp 
where r.orderID = form.orderID and form.customerID = c.customerID and go.orderID = form.orderID and go.goodsSKUID = gs.goodSKUID and gs.goodID = g.goodID and gs.goodSKUID = sp.goodsskuid
group by r.refundID, r.orderID, form.customerID, c.customerPhone, form.orderTime, gs.goodSKUID, g.goodName,sp.specificationParameter, gs.currentPrice, go.goodQty
with read only







--评论
create view view_comments
as
select co.goodID, g.goodName, co.customerID, c.customerNickName, co.commentTime, co.commentContent,co.judgeLevel, co.browseTimes
from comments co, customer c, good g
where co.customerID = c.customerID and co.goodID = g.goodID
group by co.goodID, g.goodName, co.customerID, c.customerNickName, co.commentTime, co.commentContent,co.judgeLevel, co.browseTimes
with read only




