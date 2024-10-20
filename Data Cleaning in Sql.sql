-- Cleaning Data in TSql:

select * from [03_Customer_Behavior_Data] 
select * from [03_Item_Information_Data] 
select * from [03_Shelf_Information_Data]

/* Bảng Customer_Behavior*/
select * from [03_Customer_Behavior_Data] 

-- 1. Kiểm tra và xử lý các giá trị Null (missing value)
select * 
from [03_Customer_Behavior_Data]
where Putting_item_into_bag  Is null or Taking_item_out_of_bag Is null or Putting_item_into_bag_in_the_2nd_time Is null

     -- Xóa các giá trị Null 
Delete 
from [03_Customer_Behavior_Data]
where Putting_item_into_bag  Is null or Taking_item_out_of_bag Is null or Putting_item_into_bag_in_the_2nd_time Is null

-- 2. Loại bỏ các dữ liệu bị trùng lặp (Remove Duplicates) 
Delete
from [03_Customer_Behavior_Data]
where Person_ID In ( select Person_ID from  [03_Customer_Behavior_Data] group by [Person_ID], [Timestamp] having COUNT(*) > 1) -- không có trùng lặp 


/* Bảng Item_Information*/
 select * from [03_Item_Information_Data] 

-- 1. Kiểm tra và xử lý các giá trị Null (missing value)
Select *
from [03_Item_Information_Data]
where Weight_g is null or NSX is null or HSD is null 
      -- Xóa các giá trị Null 
Delete
from [03_Item_Information_Data]
where Weight_g is null or NSX is null or HSD is null

-- 2. Kiểm tra tính hợp lệ của mã sản phẩm
SELECT Shelf_id, item_id 
     , COUNT(item_id)
from [03_Item_Information_Data] 
group by shelf_id, Item_id 
Having COUNT(item_id) > 1  -- hợp lệ 

-- 3. Lấy số ký tự nhất định, bỏ đơn vị giá, cập nhật cột mới vào bảng 
Update [03_Item_Information_Data] 
set Price = left ([Price],charindex (' ', Price)-1)

-- 4. Thay thế ký tự trong chuỗi 
Update  [03_Item_Information_Data] 
Set Price = replace (Price, ',','.') 

-- 5. Chuẩn hóa định dạng dữ liệu và kiểm tra giá trị sản phẩm 
Select * 
     , cast ([Price] as float ) as price_item 
from [03_Item_Information_Data]
where cast ([Price] as float ) <= 0 or cast ([Price] as float ) > 1000 -- không có giá trị bất thường 


/*Bảng Shelf_Information*/
select * from [03_Shelf_Information_Data]

-- 1. Kiểm tra sự phù hợp thông tin kệ hàng và sản phẩm với bảng Item_Information
Select distinct  Shelf.Shelf_ID, Number_of_items
    , count (Item_ID) over (partition by Item.Shelf_ID) as Number_items 
from [03_Shelf_Information_Data] as Shelf
left join [03_Item_Information_Data] as Item
     on Shelf.Shelf_ID = Item.Shelf_ID
    order by Shelf.Shelf_ID asc  -- Thiếu thông tin sản phẩm của kệ 1, 7. Không có thông tin sản phẩm của kệ 5,6 




 
