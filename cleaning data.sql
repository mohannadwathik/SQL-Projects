--cleaning data 



select *
from Nashvillehousing



--formating saledate

select SaleDate, CONVERT(date,SaleDate)
from Nashvillehousing

alter table Nashvillehousing
add SaleDateConverted date;

update Nashvillehousing
set SaleDate =  CONVERT(date,SaleDate)




--populate the propertyaddress


select PropertyAddress
from Nashvillehousing



select n1.PropertyAddress, n1.ParcelID,  n2.PropertyAddress, n2.ParcelID , isnull(n1.PropertyAddress, n2.PropertyAddress)
from Nashvillehousing as n1
join Nashvillehousing as n2
on n1.ParcelID = n2.ParcelID and n1.[UniqueID ] <> n2.[UniqueID ]
where n1.PropertyAddress is null 


update n1
set PropertyAddress =  isnull(n1.PropertyAddress, n2.PropertyAddress)
from Nashvillehousing as n1
join Nashvillehousing as n2
on n1.ParcelID = n2.ParcelID and n1.[UniqueID ] <> n2.[UniqueID ]
where n1.PropertyAddress is null 


-- breaking out property address into individual

select PropertyAddress
from Nashvillehousing

select PARSENAME(replace(PropertyAddress,',' , '.'),2),PARSENAME(replace(PropertyAddress,',' , '.'),1)
from Nashvillehousing


alter table Nashvillehousing
add PropertySplitAddress Nvarchar (300);

update Nashvillehousing
set PropertySplitAddress  =  PARSENAME(replace(PropertyAddress,',' , '.'), 2)
from Nashvillehousing



alter table Nashvillehousing
add PropertySplitCity Nvarchar (300);

update Nashvillehousing
set PropertySplitCity  =  PARSENAME(replace(PropertyAddress,',' , '.'), 1)
from Nashvillehousing


-- Y and N in sold as vacant


select distinct (SoldAsVacant), count(SoldAsVacant)
from Nashvillehousing
group by SoldAsVacant
order by 2



select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from Nashvillehousing


update Nashvillehousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end







--remove duplicates
with row_numCTE as(
select *, 
     row_number () over(
	 partition by
	       LegalReference,
	       ParcelID,
	       SalePrice,
	       SaleDate
	       order by
	         UniqueID
		     )as row_num

from Nashvillehousing
)
select*
from row_numCTE
where row_num >1



--delete unused columns

select*
from Nashvillehousing

alter table Nashvillehousing
drop column PropertyAddress, SaleDate,TaxDistr


alter table Nashvillehousing
drop column OwnerAddress




