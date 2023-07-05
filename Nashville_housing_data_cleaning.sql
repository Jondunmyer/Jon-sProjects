--Data Cleaning Nashville housing 
SELECT * 
FROM [dbo].[Nashville Housing Data for Data Cleaning]


-- Date format



Alter Table [dbo].[Nashville Housing Data for Data Cleaning]
DROP Column SaleDateConverted

Select *
From [dbo].[Nashville Housing Data for Data Cleaning]






-- Populate Property Address Data




Select *
From [dbo].[Nashville Housing Data for Data Cleaning]
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[Nashville Housing Data for Data Cleaning] a
JOIN [dbo].[Nashville Housing Data for Data Cleaning] b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[Nashville Housing Data for Data Cleaning] a
JOIN [dbo].[Nashville Housing Data for Data Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



---Breaking out Address into Individual Columns (Address, City, State)



Select PropertyAddress
From [dbo].[Nashville Housing Data for Data Cleaning]
--Where PropertyAddress is null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
From [dbo].[Nashville Housing Data for Data Cleaning]

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [dbo].[Nashville Housing Data for Data Cleaning]

ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
Add PropertySplitAddress Nvarchar(255);

Update [dbo].[Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
Add PropertySplitCity Nvarchar(255);

Update [dbo].[Nashville Housing Data for Data Cleaning]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT * 
FROM [dbo].[Nashville Housing Data for Data Cleaning]




Select OwnerAddress
From [dbo].[Nashville Housing Data for Data Cleaning]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [dbo].[Nashville Housing Data for Data Cleaning]

ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
Add OwnerSplitAddress Nvarchar(255);

Update [dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
Add OwnerSplitCity Nvarchar(255);

Update [dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
Add OwnerSplitState Nvarchar(255);

Update [dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



SELECT * 
FROM [dbo].[Nashville Housing Data for Data Cleaning]

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [dbo].[Nashville Housing Data for Data Cleaning]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = '1' THEN 'Yes'
	   When SoldAsVacant = '0' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [dbo].[Nashville Housing Data for Data Cleaning]

Alter table [dbo].[Nashville Housing Data for Data Cleaning]
Alter column SoldAsVacant VARCHAR(10)

Update [dbo].[Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = CASE When SoldAsVacant = '1' THEN 'Yes'
	   When SoldAsVacant = '0' THEN 'No'
	   ELSE SoldAsVacant
	   END

SELECT * 
FROM [dbo].[Nashville Housing Data for Data Cleaning]





--- Removing Duplicates 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [dbo].[Nashville Housing Data for Data Cleaning]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


---Removing unused Columns

SELECT * 
FROM [dbo].[Nashville Housing Data for Data Cleaning]

ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 