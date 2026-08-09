function OnInit()

	EGroup_SetAnimatorState(<Any Egroup name>, "<Any State Animator>", "<Any trigger animator>")
	SGroup_SetAnimatorState(<Any Sgroup name>, "<Any State Animator>", "<Any trigger animator>")

end

Scar_AddInit(OnInit)
