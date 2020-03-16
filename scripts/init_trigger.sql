/*
 * CREATE TRIGGER TO SET COW'S DEATH
 */
CREATE OR ALTER TRIGGER Schlachtung_Rind_Trigger 
on Schlachtung
AFTER INSERT 
as
begin
	declare @R_ID int
    select @R_ID=R_ID from inserted
    if (SELECT lebendig from Rind where Rind.ID=@R_ID) = 1
	begin	
    	UPDATE Rind set Lebendig=0 WHERE Rind.ID=@R_ID 
	end
    else
    begin 
	    RAISERROR('Cow is already dead!',11,1)
    end
END;