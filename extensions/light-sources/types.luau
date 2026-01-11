export type Reposition = {
	name: string,
	describedBy: string,

	updateDirection: (initial: RepositionState, now: RepositionState, showGizmos: boolean) -> Vector3?,
}

export type RepositionState = {
	clockTime: number,
	geographicLatitude: number,
	sunDirection: Vector3,
	mouseTransform: CFrame,
	cameraTransform: CFrame,
}

export type Source = {
	name: string,
	updateDirection: (direction: Vector3) -> (),
}

return nil
