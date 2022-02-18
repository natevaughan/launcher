import type { RequestEvent } from '@sveltejs/kit/types/hooks';
import type { EndpointOutput } from '@sveltejs/kit/types/endpoint';
import { prisma } from '$lib/prismaClient';
import type { Role } from '@prisma/client';
import validateUser from '$lib/validateUser';
import { BAD_REQUEST, UNAUTHORIZED } from '$lib/responseConstants';

export async function get(event: RequestEvent): Promise<void | EndpointOutput> {
	const user = await validateUser(event.request, prisma);

	const role = await prisma.role.findFirst({
		where: {
			userId: user.id
		},
		select: {
			organization: true
		}
	});

	if (role) {
		return {
			body: role
		};
	} else {
		return {
			status: 404
		};
	}
}

export async function post(event: RequestEvent): Promise<void | EndpointOutput> {
	const user = await validateUser(event.request, prisma);

	if (!user) {
		return UNAUTHORIZED
	}

	if (!event.request.body) {
		return BAD_REQUEST
	}
	let role: Role;

	try {
		const dateCreated = new Date().toISOString();
		const body = await event.request.json()
		role = await prisma.role.create({
			data: {
				user: { connect: { id: user.id } },
				organization: { connect: {id: body.organizationId } },
				roleType: body.roleType,
				dateCreated: dateCreated,
				lastModified: dateCreated
			}
		});
	} catch (e: unknown) {
		console.error(e);
		return {
			status: 400
		};
	}

	if (role) {
		return {
			status: 201,
			body: role
		};
	} else {
		return {
			status: 500
		};
	}
}
