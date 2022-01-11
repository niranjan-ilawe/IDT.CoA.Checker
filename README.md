IDT CoA Checker 
----------
v 1.0.0

### Usage

1. Select "Checker" tab in the left side panel.
2. Upload the relevant CoA file.
3. Upload the corresponding Order file.
4. Click on the "Check" button.
5. A report of the analysis should appear on the screen to the right of the buttons. (as shown in the picture below)
6. Click on the "Download" button to download the analysis table to your computer

![Check](img/check_coa.png)

7. If anything fails, a pop-up message should give more information about the cause of error

### Assumptions

There are a few assumptions that are made within the code. These are explained in detail below

1. Input
    * Input
    * Accepts a clean CSV CoA File (i.e needs to be cleaned by the “Clean CoA file” tab)
    * Accepts a clean CSV Order File (i.e needs to be cleaned by the “Clean Order file” tab)
    * The raw files before cleaning 
        - Should have the columns “plate name”, “well position”, “sequence name” and “sequence”
        - Should also have columns “volume” and “concentration”
        - Can have all the columns as sent by the vendor

2. Checks Done
    * Outputs number of sequences in both files
    * Outputs number of matches of sequences
    * Checks if the “plate_name”, “well_position”, “sequence_name” and “sequence” in both files match with one another
    * Outputs Pass only if all sequences, on the same plate and at the same well position, match with each other.
    * Outputs Pass only if the volumes of the sequences in the CoA are the same or more than at most 20uL than the order file.
    * Outputs Pass only if the concentration of sequences in the order file is within +- 20% of the concentration in the order file.

### Cleaning CoA File

Sometimes, the vendor sends a combined CoA file, for many plates/orders in one file. This cleaning utility was added to the app to make this cleaning easier. And not rely on the manual cut-paste operations.

1. Select "Clean CoA File" tab in the left side panel.
2. Select appropriate vendor.
3. Upload the raw CoA File.
4. The selection box labeled "Choose columns to Filter By" should be populated by the column names in the raw CoA file.
5. Choose a column name to filter by.
6. The selection box labeled "Choose values to Filter" should be populated by the unique values in the above selected columns.
7. Choose the appropriate value to filter by.
8. Click on "Add to Filter". The text box on the top right should show the filters selected.
9. Repeat this as many times as needed.
10. Click on "View Filtered Data" to display the filtered data on the right.
11. Click on "Download Clean File" to download the clean CoA file containing only the filtered data.

![Clean_CoA](img/clean_coa.png)

### Cleaning Order File

The Order files come in various flavours. The sheet in which the actual data is located varies. This cleaning utility tries to make it a little flexible to get this data without relying on manual cut-paste operations

1. Select "Clean Order File" tab in the left side panel.
2. Select appropriate vendor.
3. Upload the raw Order file.
4. The sheet name selection box should now be populated.
5. Choose the appropriate sheet from which data should be pulled.
6. Click on "View Order Data" to make sure the data looks OK.
7. Click on "Download Clean File" to download the clean Order file.

![Clean_Order](img/clean_order.png)