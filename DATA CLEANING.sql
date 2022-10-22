---*** DATA CLEANING ***----
use covid;

select *  from housing$;

---1.standardize the date format---
select SaleDate,convert(Date,SaleDate) from housing$ as SalesDate;

alter table housing$
add SaleDateConverted Date;

update housing$
set SaleDateConverted =convert(Date,SaleDate);


---2.PropertyAddress is null----

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from housing$ a
join housing$ b
on a.ParcelID=b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from housing$ a
join housing$ b
on a.ParcelID=b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

---3.Breaking out address into individual columns(Address,city,state)---------
select 
substring(PropertyAddress,1,charindex(',',propertyAddress) -1 ) as Address
, substring(PropertyAddress,charindex(',',propertyAddress) +1,len(PropertyAddress))as Address
from housing$;

alter table housing$
add PSA varchar(255);

update housing$
set PSA = substring(PropertyAddress,1,charindex(',',propertyAddress)

alter table housing$
add PSC nvarchar(255);

update housing$
set PSC =substring(propertyAddress,charindex(',',propertyAddress) +1,len(PropertyAddress))

select * from housing$;
------or-----------------
select
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from housing$;

---4.change Y and N to Yes and No in "SoldAsVacant" field

select distinct(SoldAsVacant),count(SoldAsVacant)
from housing$
group by SoldAsVacant
order by 2;

select SoldAsVacant
,case when SoldAsVacant ='y' then 'Yes'
      when SoldAsVacant ='n'then 'No'
	  else SoldAsVacant
	  end
from housing$;

update housing$
set SoldAsVacant= case when SoldAsVacant ='y' then 'Yes'
                       when SoldAsVacant ='n'then 'No'
	                   else SoldAsVacant
	                   end;

go

---5.Removing Duplicates------

with RowNumCTE as(
select * ,
    row_number() over(
	partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by UniqueID) row_num
from housing$)

select * from RowNumCTE
where row_num >1
order by PropertyAddress

delete from RowNumCTE
where row_num > 1
------------it should be execute at the same time by selecting two at once-------------

---6.deleteing the unused columns---------------------

select * from housing$;

alter table housing$
drop column HalfBath























