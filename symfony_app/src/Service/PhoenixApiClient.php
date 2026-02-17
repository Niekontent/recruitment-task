<?php

namespace App\Service;

use Symfony\Contracts\HttpClient\HttpClientInterface;
use Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface;
use Symfony\Contracts\HttpClient\Exception\ClientExceptionInterface;
use Symfony\Contracts\HttpClient\Exception\ServerExceptionInterface;

class PhoenixApiClient
{
    private HttpClientInterface $client;
    private string $baseUrl;
    private ?string $apiToken;

    public function __construct(HttpClientInterface $client, string $baseUrl, ?string $apiToken = null)
    {
        $this->client = $client;
        $this->baseUrl = rtrim($baseUrl, '/');
        $this->apiToken = $apiToken;
    }

    private function request(string $method, string $url, array $options = []): array
    {
        $headers = $options['headers'] ?? [];

        if ($this->apiToken) {
            $headers['Authorization'] = $this->apiToken;
        }

        $options['headers'] = $headers;

        try {
            $response = $this->client->request($method, $this->baseUrl . $url, $options);
            return $response->toArray();
        } catch (TransportExceptionInterface|ClientExceptionInterface|ServerExceptionInterface $e) {
            return [];
        }
    }

    // ---------- USERS ----------

    public function listUsers(array $filters = []): array
    {
        return $this->request('GET', '/api/users', ['query' => $filters]);
    }

    public function getUser(int $id): array
    {
        return $this->request('GET', "/api/users/{$id}");
    }

    public function createUser(array $data): array
    {
        return $this->client->request('POST', $this->baseUrl . '/api/users', [
            'json' => $data
        ])->toArray();
    }

    public function updateUser(int $id, array $data): array
    {
        return $this->client->request('PUT', $this->baseUrl . '/api/users/' . $id, [
            'json' => $data
        ])->toArray();
    }

    public function deleteUser(int $id): void
    {
        $this->request('DELETE', '/api/users/' . $id);
    }
}
