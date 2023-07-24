-- Cleaning Data in SQL Queries

SELECT * 
FROM NashvilleHousing;

-- Standardize Date Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- Populate Property Address data

SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE [PropertyAddress] is null
ORDER BY [Parcel ID]

SELECT a.[Parcel ID], a.PropertyAddress, b.[Parcel ID] , b.PropertyAddress , ISNULL(a.[Property City], b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.[Parcel ID] = b.[Parcel ID]
AND a.UniqueID  <> b.UniqueID
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.[Property City], b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.[Parcel ID] = b.[Parcel ID]
AND a.UniqueID  <> b.UniqueID
WHERE a.PropertyAddress IS NULL


SELECT PropertyAddress 
FROM PortfolioProject..NashvilleHousing


--  Breaking out Address into Individual Columns (Address, City , State)


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM PortfolioProject..NashvilleHousing


SELECT Address
FROM PortfolioProject..NashvilleHousing

SELECT  
PARSENAME(REPLACE(Address,' ','.'), 3),
PARSENAME(REPLACE(Address,' ','.'),2),
PARSENAME(REPLACE(Address,' ','.'),1)
FROM PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(Address, ' ', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(Address, ' ', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(Address, ' ', '.') , 1)


SELECT OwnerSplitAddress,  OwnerSplitCity ,OwnerSplitState 
FROM PortfolioProject..NashvilleHousing


-- Changing  Y and N to Yes and NO in 'sold as Vacant' field



SELECT DISTINCT(SoldAsVacant) , COUNT(SoldASVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldASVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant= 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing




-- Removing Duplicates

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY [Parcel ID],
				 [PropertyAddress],
				 [Sale Price],
				 [SaleDate],
				 [Legal Reference]
				 ORDER BY 
				 UNiqueID
				 ) row_num
FROM PortfolioProject..NashvilleHousing
--ORDER BY [Parcel ID]
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



-- DELETE UNSEND COLUMNS

SELECT *
FROM PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate