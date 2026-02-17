<?php

namespace App\Controller;

use App\Service\PhoenixApiClient;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Psr\Log\LoggerInterface;

class UserController extends AbstractController
{
    private PhoenixApiClient $api;

    public function __construct(PhoenixApiClient $api)
    {
        $this->api = $api;
    }
    public function index(Request $request): Response
    {
        $filters = [
            'first_name'      => $request->query->get('first_name', ''),
            'last_name'       => $request->query->get('last_name', ''),
            'gender'          => $request->query->get('gender', ''),
            'birthdate_from'  => $request->query->get('birthdate_from', ''),
            'birthdate_to'    => $request->query->get('birthdate_to', ''),
            'sort_by'         => $request->query->get('sort_by', 'id'),
            'sort_order'      => $request->query->get('sort_order', 'asc'),
        ];

        $filters = array_filter($filters, fn($v) => $v !== null && $v !== '');

        $users = $this->api->listUsers($filters);

        return $this->render('user/index.html.twig', [
            'users' => $users,
            'filters' => $filters
        ]);
    }

    public function new(): Response
    {
        return $this->render('user/form.html.twig', [
            'action' => 'Create',
            'user' => [],
        ]);
    }

    public function create(Request $request, LoggerInterface $logger): JsonResponse
    {
        $data = $request->request->all();
        $logger->info('Create user data:', $data);

        try {
            $user = $this->api->createUser($data);
            return new JsonResponse($user, 201);
        } catch (\Exception $e) {
            return new JsonResponse(['error' => $e->getMessage()], 500);
        }
        die();
    }
    
    public function edit(int $id): Response
    {
        $user = $this->api->getUser($id);

        return $this->render('user/form.html.twig', [
            'user' => $user,
            'action' => "Update"
        ]);
    }

    public function update(int $id, Request $request): JsonResponse
    {
        $data = $request->request->all();

        try {
            $user = $this->api->updateUser($id, $data);
            return new JsonResponse($user);
        } catch (\Exception $e) {
            return new JsonResponse(['error' => $e->getMessage()], 500);
        }
    }

    public function delete(int $id): Response
    {
        try {
            $this->api->deleteUser($id);
        } catch (\Throwable $e) {
            $this->addFlash('error', 'Failed to delete user');
        }

        return $this->redirectToRoute('user_index');
    }

}
